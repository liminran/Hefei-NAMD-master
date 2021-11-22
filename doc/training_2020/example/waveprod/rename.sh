#!/bin/bash
cd run/
for i in `ls`
do
#    newfile = `echo a$i`
    mv  -f $i `echo a$i`
done

#for i in `ls`;do print `echo a$i`;done
#for i in `ls`;do mv -f $i `echo $i | sed 's/_//'`;done