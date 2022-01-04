#!/bin/bash
cd run/
#add a
#for i in `ls`
#do
#    mv  -f $i `echo a$i`
#done
# del a
for i in `ls`;do mv -f $i `echo $i | sed 's/a//'`;done


#sed -i 's/C2/C/g' water.gro


