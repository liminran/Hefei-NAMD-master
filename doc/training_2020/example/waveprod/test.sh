#!/bin/bash
#cd run
#ls -l {0001..2000}/WAVECAR | awk '{print $5}' | uniq -c
qstat -f |awk "print $1 $2 $3 $4 $5 $0"
qstat -f | awk  '{print "first:"$1"second:" $2 "third:" $3}' >data
qstat -f |awk  '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF ",linecontent:"$0}'
qstat -f | awk  '/@/{print "first:"$1" second:" $0 " third:" $3}'


cat data | awk -F '/' 'BEGIN{count=0; printf("t2:%s,t3:%s\n",$2,$3)}{if($2 != $3){count=count+1;print NR}}'

qstat -f | awk  '{print $3}' > data
cat data | awk -F '/' 'BEGIN{count=0}{if($2 != $3){count=count+1;print NR " " $3}}' > dataNR
qstat -f | awk -F '[/]' '/@/{print $3}'
qstat -f | awk -F '[/\t'BIP']' 'BEGIN{COUNT=0}{if($3 != $4 && $6==’lx-amd64‘){print NR,$0,NF}}'

qstat -f | awk  '/@/{print $0}' > data
cat data | awk -F '[/\t'BIP']' 'BEGIN{COUNT=0}{if($3 != $4){count=count+1;print NR,$0,NF}}'
cat data | awk -F '[/\t'BIP']' '{print $0}'


