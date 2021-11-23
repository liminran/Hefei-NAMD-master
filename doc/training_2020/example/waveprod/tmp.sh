#!/bin/bash
sum=5
for i in `ls` ;
do
  a=$((5-$sum))
  echo "this is a:"$a
   if [ $sum -ge 1 ]; then
  echo "Run new file, refresh node, select node"
  sum=$((sum-1))
  echo $sum
  continue
  echo "123"
fi
done