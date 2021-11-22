#!/bin/bash
START = 1
END = 2000
for i in 'seq ${START} ${END}'
do
  ((j = i-8))
  ii = 'printf "%04d" $i'
  jj = 'printf "%04d" $j'
  if [ [-d "run/${ii}"] ]; then
    cd run/${ii}
    if [ [-f RUNNING || -f ENDED] ]; then
      cd ../..
      continue
    fi
    touch RUNNING  #新建空文件
    echo "#### RUNNING in DIR: RUN/${ii}"
    sleep 0.4
    [[-s ../${jj}/CHGCAR]]&& cp ../${jj}/CHGCAR .
    $OPEN_MPI $IB_FLAG -np $NCPUS -machinefile ${HOSTFILR} $VASP—EXEC
    if [ grep "Total CPU" OUTCAR >& /dev/null]; then
      touch ENDED
    else
      rm ENDED 2>/dev/null
    fi
    rm RUNNING CHG vasprun.xml
    cd ../..
  fi
done

echo "this is $queue_name $number_of_cpus"
