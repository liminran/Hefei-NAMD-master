#!/bin/bash
START=1
END=2000

a='a'
b='.dqs'
for i in $(seq $START 1 $END)
do
  filename=$a$i
  delname=$filename$b
  echo $delname

#  ((j = i-8))
#  ii = 'printf "%04d" $i'
#  jj = 'printf "%04d" $j'
#  echo 'print' ${a}${ii}
  if [ -d "run/${filename}" ]; then   #存在文件名
    cd run/${filename}
    echo 'file:'$filename
    if [ -d "$delname" ]; then
      echo "该文件正在执行"
      cd ../../
      continue
    fi
    cd ../../
#    if [[ -f RUNNING || -f ENDED ]]; then
#      cd ../..
#      continue
#    fi
#    touch RUNNING  #新建空文件
#    echo "#### RUNNING in DIR: RUN/a${ii}"
#    sleep 0.4
#    [[-s ../a${jj}/CHGCAR]]&& cp ../a${jj}/CHGCAR .
#    $OPEN_MPI $IB_FLAG -np $NCPUS -machinefile ${HOSTFILR} $VASP—EXEC
#    if [ grep "Total CPU" OUTCAR >& /dev/null]; then  # 后台运行，输出到空设备
#      touch ENDED
#    else
#      rm ENDED 2>/dev/null  #1代表标准输出，2代表错误信息输出.
#    fi
#    rm RUNNING CHG vasprun.xml
#    cd ../..
  fi


#echo "this is $queue_name $number_of_cpus"
#START = 1
#END = 2000
#for i in 'seq ${START} ${END}'
#do
#  ((j = i-8))
#  ii = 'printf "%04d" $i'
#  jj = 'printf "%04d" $j'
#  if [ [-d "run/${ii}"] ]; then
#    cd run/${ii}
#    if [ [-f RUNNING || -f ENDED] ]; then
#      cd ../..
#      continue
#    fi
#    touch RUNNING  #新建空文件
#    echo "#### RUNNING in DIR: RUN/${ii}"
#    sleep 0.4
#    [[-s ../${jj}/CHGCAR]]&& cp ../${jj}/CHGCAR .
#    $OPEN_MPI $IB_FLAG -np $NCPUS -machinefile ${HOSTFILR} $VASP—EXEC
#    if [ grep "Total CPU" OUTCAR >& /dev/null]; then
#      touch ENDED
#    else
#      rm ENDED 2>/dev/null
#    fi
#    rm RUNNING CHG vasprun.xml
#    cd ../..
#  fi
#done

done