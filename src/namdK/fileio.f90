module fileio
  use prec

  implicit none

  type namdInfo
    integer :: BMIN
    integer :: BMAX
    integer :: NBASIS      ! No. of adiabatic states as basis
    integer :: NBANDS      ! No. of band of the system
    integer :: INIBAND     ! inititial adiabatic state of excited electron/hole
    integer :: NSW         ! No. of MD steps
    integer :: NAMDTINI    ! Initial time step of NAMD
    integer :: NAMDTIME    ! No. of steps of NAMD
    integer :: RTIME    ! No. of steps of NAMD It is not recommended to replicate NAC in FSSH
    integer, allocatable, dimension(:) :: NAMDTINI_A    ! No. of steps of NAMD
    integer, allocatable, dimension(:) :: INIBAND_A     ! No. of steps of NAMD

    integer :: NTRAJ       ! No. of surface hopping trajectories
    integer :: NELM        ! No. of steps of electron wave propagation
    integer :: NSAMPLE     ! No. of steps of electron wave propagation
    integer :: NACBASIS
    integer :: NELECTRON
    real(kind=q) :: POTIM  ! Time step of MD run
    real(kind=q) :: TEMP   ! MD Temperature

    ! hole or electron surface hopping
    logical :: LHOLE
    ! whether to perform surface hopping, right now the value is .TRUE.
    logical :: LSHP
    ! whether to perform DISH, right now the value is .TRUE.
    logical :: LDISH   !!
    logical :: LCPTXT
    logical :: LSPACE
    ! running directories
    character(len=256) :: RUNDIR
    character(len=256) :: TBINIT
    character(len=256) :: DIINIT   !! input of pure dephasing time matrix
    integer, allocatable, dimension(:,:) :: ACBASIS ! Active Space Basis Macrostate
    real(kind=q), allocatable, dimension(:,:) :: DEPHMATR     !! Pure dephasing time between any two adiabatic states from the file DEPHTIME, fs unit
  end type

  contains

    subroutine getUserInp(inp)
      implicit none

      type(namdInfo), intent(inout) :: inp

      ! local variables with the same name as those in "inp"
      integer :: bmin
      integer :: bmax
      integer :: nsw
      integer :: iniband
      integer :: nbands
      integer :: namdtime
      integer :: realtime
      ! integer :: namdtini
      integer :: ntraj
      integer :: nelm
      integer :: nsample
      integer :: nacbasis
      integer :: nelectron
      real(kind=q) :: potim
      real(kind=q) :: temp

      ! hole or electron surface hopping
      logical :: lhole
      ! surface hopping?
      logical :: lshp
      logical :: ldish   !!
      logical :: lcpext
      logical :: lspace
      ! running directories
      character(len=256) :: rundir
      character(len=256) :: tbinit
      character(len=256) :: diinit   !!
      character(len=256) :: spinit

      namelist /NAMDPARA/ bmin, bmax, nsw,    &
                                   nbands,    &
                          potim, ntraj, nelm, &
                          temp, rundir,       &
                          !! lhole, ldish, lcpext,&
                          lhole, lshp, lcpext,&
    !!                      lspace,nacbasis,nelectron,     &   !!
                          namdtime,realtime,    &
                          !! nsample, tbinit
                          nsample, tbinit, diinit  !!

      integer :: ierr, i, j
      logical :: lext

      ! set default values for thos parameters
      rundir = 'run'
      tbinit = 'INICON'
      diinit = 'DEPHTIME'  !!
      spinit = 'ACSPACE'
      bmin = 0
      bmax = 0
      nbands = 0
      ! iniband = 0
      ntraj = 1000
      nelm = 10
      lhole = .FALSE.
      lshp = .TRUE.
      ldish = .FALSE.
      ! namdtini = 1
      namdtime = 200
      realtime = 2
      potim = 1.0_q
      temp = 300_q
      lcpext = .FALSE.
      lspace = .FALSE.
      nacbasis = 100
      nelectron = 100
      open(file="inp", unit=8, status='unknown', action='read', iostat=ierr)
      if ( ierr /= 0 ) then
        write(*,*) "I/O error with input file: 'inp'"
        stop
      end if

      read(unit=8, nml=NAMDPARA)
      close(unit=8)

      if ( mod(nelm, 2) /= 0 ) then      
         write(*,*) "NELM should be a even number"
         stop
      end if

      allocate(inp%INIBAND_A(nsample), inp%NAMDTINI_A(nsample))
      inquire(file=tbinit, exist=lext)
      if (.NOT. lext) then
        write(*,*) "File containing initial conditions does NOT exist!"
        stop
      else
        open(unit=9, file=tbinit, action='read')
        do i=1, nsample
          read(unit=9,fmt=*) inp%NAMDTINI_A(i), inp%INIBAND_A(i)
        end do
        close(9)
      end if
      
      if (ldish) then
        allocate(inp%DEPHMATR(bmax - bmin + 1, bmax - bmin + 1))   !! read in the pure dephasing time matrix, the diagonal elements are zero
        inquire(file=diinit, exist=lext)
        if (.NOT. lext) then
          write(*,*) "File containing initial conditions of DISH does NOT exist!"
          stop
        else
          open(unit=10, file=diinit, action='read')
          read(unit=10, fmt=*) ((inp%DEPHMATR(i,j), j=1, bmax - bmin + 1), i=1, bmax - bmin + 1)
          do i = 1, bmax - bmin + 1
            do j = 1, bmax - bmin + 1
              if (i /= j) then
                inp%DEPHMATR(j,i) = 1.0_q / inp%DEPHMATR(j, i)
              end if
            end do
          end do
          ! do i=1, bmax - bmin + 1
          !   do j=1, bmax - bmin + 1
          !     read(unit=10,fmt=*) inp%DEPHMATR(i, j)
          !   end do
          ! end do
          close(10)
        end if
      end if
  
      if (lspace) then
        allocate(inp%ACBASIS(nacbasis, nelectron))
        inquire(file=spinit, exist=lext)
        if (.NOT. lext) then
          write(*,*) "File containing Active Space does NOT exist!"
          stop
        else
          open(unit=11, file=spinit, action='read')
          read(unit=11, fmt=*) ((inp%ACBASIS(i,j),j=1,nelectron),i=1,nacbasis)
          close(11)
        end if

      end if

      if (realtime<=namdtime) then
        realtime=namdtime
      else
        if (.NOT. ldish) then 
          write(*,*) "We do not recommend replicating NAC in FSSH"
          write(*,*) "Used NAMDTIME instead of REALTIME"
          realtime=namdtime
        end if
      end if
      ! do some checking...
      ! put the following checks in the future version
      ! if (bmin <= 0 .OR. bmax <= 0 .OR. bmin >= bmax) then
      !   write(*,*) "Please specify the correct BMIN/BMAX"
      !   stop
      ! end if

      ! if (iniband == 0 .OR. iniband < bmin .OR. iniband > bmax) then
      !   write(*,*) "Please specify the correct initial band!"
      !   stop
      ! end if

      ! if (nbands == 0) then
      !   write(*,*) "I need the No. of bands..."
      !   stop
      ! end if

      ! if (namdtini + namdtime - 1 > nsw) then
      !   write(*,*) "NAMDTIME too long..."
      !   stop
      ! end if
      ! here ends the currently simplified version of parameter checking

      ! assign the parameters
      inp%BMIN     = bmin
      inp%BMAX     = bmax
      inp%NBASIS   = bmax - bmin + 1
      inp%NSW      = nsw
      inp%NBANDS   = nbands
      inp%NAMDTIME = realtime 
      inp%NTRAJ    = ntraj
      inp%NELM     = nelm
      inp%LHOLE    = lhole
      inp%LSHP     = lshp
      inp%RTIME    = realtime
      inp%LDISH    = ldish
      inp%RUNDIR   = trim(rundir)
      inp%TBINIT   = trim(tbinit)
      inp%DIINIT   = trim(diinit)   !!
      inp%NSAMPLE  = nsample
      inp%POTIM    = potim
      inp%LSPACE   = lspace
      inp%NACBASIS = nacbasis
      inp%NELECTRON= nelectron
      inp%LCPTXT   = lcpext
      inp%TEMP     = temp
    end subroutine

    ! Need a subroutine to print out all the input parameters
    subroutine printUserInp(inp)
      implicit none
      type(namdInfo), intent(in) :: inp

      write(*,'(A)') "------------------------------------------------------------"
      write(*,'(A30,A3,I8)') 'BMIN',     ' = ', inp%BMIN
      write(*,'(A30,A3,I8)') 'BMAX',     ' = ', inp%BMAX
      write(*,'(A30,A3,I8)') 'INIBAND',  ' = ', inp%INIBAND
      write(*,'(A30,A3,I8)') 'NBANDS',   ' = ', inp%NBANDS

      write(*,'(A30,A3,I8)')   'NSW',    ' = ', inp%NSW
      write(*,'(A30,A3,F8.1)') 'POTIM',  ' = ', inp%POTIM
      write(*,'(A30,A3,F8.1)') 'TEMP',   ' = ', inp%TEMP

      write(*,'(A30,A3,I8)') 'NAMDTINI', ' = ', inp%NAMDTINI
      write(*,'(A30,A3,I8)') 'NAMDTIME', ' = ', inp%NAMDTIME
      !!write(*,'(A30,A3,I8)') 'NAMDRTIME', ' = ', inp%RTIME
      write(*,'(A30,A3,I8)') 'NTRAJ',    ' = ', inp%NTRAJ
      write(*,'(A30,A3,I8)') 'NELM',     ' = ', inp%NELM

      write(*,'(A30,A3,L8)') 'LHOLE',    ' = ', inp%LHOLE
      write(*,'(A30,A3,L8)') 'LSHP',     ' = ', inp%LSHP
      !!write(*,'(A30,A3,L8)') 'LDISH',    ' = ', inp%LDISH
      write(*,'(A30,A3,L8)') 'LCPTXT',   ' = ', inp%LCPTXT
      write(*,'(A30,A3,A)')  'RUNDIR',   ' = ', TRIM(ADJUSTL(inp%rundir))

      write(*,'(A)') "------------------------------------------------------------"
    end subroutine

end module
