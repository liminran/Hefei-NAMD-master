#!/bin/bash
START=1
END=2000
sum=3
vasp()
{
#查看空闲节点数
qstat -f | awk  '/@/{print $0}' > data0
qstat -f | awk  '/@/{print $3}' > data
cat data | awk -F '/' 'BEGIN{count=0}{if($2 == 0){count=count+1;print NR " " $3}}' > dataNR
#提取有用的cpu
for i in `awk '{print $1}' dataNR` ; do
  a=$i
  sed -n ${a}p data0 > datacpu0
  sed -n ${a}p data0 >> datacpu
done
#运行数据
#run=1  #运行次数
for i in $(seq 1 1 ); do
    local n=$((5-$sum))
    echo "this is run number:"$n
    a=$(cat datacpu | awk -F 'natur' '{print $1}' |sed -n ${n}p)  #sed 指定行
    node=${a}natur.cuni.cz
    echo $node
    np=$(cat datacpu | awk -F '[/ ]+' '{print $5}' |sed -n ${n}p)
    echo $np
    echo "VASP-5.4.1" $node $np 2G
#    VASP-5.4.1 $node $np 2G
    sleep 5
done
rm data0 data dataNR datacpu0 datacpu
}


outcar='OUTCAR'
b='.dqs'
cd run/

for i in `ls`
do
  filename=$i
  delname=$filename$b
  echo 'This is delname:'$delname
  echo "Entry the directory:"$i
  cd ${i}/
  if [ -f "$delname" -a -f "$outcar" ]; then
      echo "The file is running"
      cd ../
#      echo `pwd`
    continue
  else
    if [ -f  "$outcar" ]; then
      echo "The file is finished"
      rm     CONTCAR *log OUTCAR     #CHG* DOSCAR vasprun.xml POTCAR CONTCAR *log
    cd ../
    continue
    fi
  fi
  sleep 5
  if [ $sum -ge 1 ]; then
    echo "Run new file, refresh node, select node"
    echo "before:"$sum
    sum=$((sum-1))
    vasp
    echo "after:"$sum
#    let sum--
  else
    echo 'Run over. exit!'
    break
  fi
  cd ../
done





#a='a'
#b='.dqs'
#outcar='OUTCAR'
#for i in $(seq $START 1 $END)
#do
#  filename=$a$i
#  delname=$filename$b
#  echo $delname
#
#  if [ -d "run/${filename}" ]; then   #存在文件名
#    cd run/${filename}
#    echo 'file:'$filename
#    if [ -d "$delname" ]; then
#      echo "The file is running"
#    else
#      if [ -d  "$outcar" ]; then
#        echo "The file is finished"
#        rm     CONTCAR *log     #CHG* DOSCAR vasprun.xml POTCAR CONTCAR *log
#      cd ../../
#      continue
#      fi
#    fi
#    sleep 10
#    echo "Run new file, refresh node, select node"
##    if [ '有节点' ]; then
##    fi
##    VASP-5.4.1 zq-20-6.4@z42.natur.cuni.cz 20  4G
#    cd ../../
#  fi


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