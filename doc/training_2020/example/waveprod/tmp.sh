#!/bin/bash
for i in {1..5} ; do

    sum=$(date +%s%N|cut -c 13)
    n=$(($sum+1))
    echo "this is run node number1:"$n
    echo ${i}
    node=3.natur.cuni.cz

    while [ $node = '5.natur.cuni.cz' -o $node = '3.natur.cuni.cz' ]; do
      echo "node before:"$node
    sum=$(date +%s%N|cut -c 13)
    n=$(($sum+1))
    echo "this is run node number2:"$n
    node=${n}.natur.cuni.cz
#    i=$(($i+1))
    echo 'node late:'$node
    done
    echo 'end:'$node
done







#for i in {1..5} ; do echo $i ;done












#sum=5
#for i in `ls` ;
#do
#  a=$((5-$sum))
#  echo "this is a:"$a
#   if [ $sum -ge 1 ]; then
#  echo "Run new file, refresh node, select node"
#  sum=$((sum-1))
#  echo $sum
#  continue
#  echo "123"
#fi
#done