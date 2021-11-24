#!/bin/bash
cd run/
for i in `ls`
do
    mv  -f $i `echo a$i`
done

