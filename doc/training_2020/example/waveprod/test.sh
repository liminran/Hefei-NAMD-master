#!/bin/bash
#cd run
#ls -l {0001..2000}/WAVECAR | awk '{print $5}' | uniq -c
#for i in `ls`;do print `echo a$i`;done
#for i in `ls`;do mv -f $i `echo $i | sed 's/_//'`;done
qstat -f |awk "print $1 $2 $3 $4 $5 $0"
qstat -f | awk  '{print "first:"$1"second:" $2 "third:" $3}' >data
qstat -f |awk  '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF ",linecontent:"$0}'
qstat -f | awk  '/@/{print "first:"$1" second:" $0 " third:" $3}'

cat data | awk -F '/' 'BEGIN{count=0; printf("t2:%s,t3:%s\n",$2,$3)}{if($2 != $3){count=count+1;print NR}}'

qstat -f | awk -F '[/]' '/@/{print $3}'
qstat -f | awk -F '[/\t'BIP']' 'BEGIN{COUNT=0}{if($3 != $4 && $6==’lx-amd64‘){print NR,$0,NF}}'
qstat -f | awk  '/@/{print $0}' > data
cat data | awk -F '[/\t'BIP']' 'BEGIN{COUNT=0}{if($3 != $4){count=count+1;print NR,$0,NF}}'
cat data | awk -F '[/\t'BIP']' '{print $0}'




qstat -f | awk  '/@/{print $0}' > data0
qstat -f | awk  '/@/{print $3}' > data
cat data | awk -F '/' 'BEGIN{count=0}{if($2 == 0){count=count+1;print NR " " $3}}' > dataNR.txt
#提取有用的cpu
for i in `awk '{print $1}' dataNR` ; do
      a=$i
  echo $a
  sed -n ${a}p data0 >> datacpu
done
#运行数据
a=5
for i in $(seq 1 5 ); do
    a=$(cat datacpu | awk -F 'natur' '{print $1}' |sed -n ${i}p)  #sed 指定行
    node=${a}natur.cuni.cz
    echo $node
    num=$(cat datacpu | awk -F '[/ ]+' '{print $5}' |sed -n ${i}p)
    echo $num
    echo "VASP-5.4.1" $node $num 4G
done

i=1
cat datacpu | awk -F 'natur' '{print $1}' |sed -n ${i}p


VASP-5.4.1 zq@z05.natur.cuni.cz 24 2G

#
#VASP-5.4.1 zq-72-3.5@z40.natur.cuni.cz 72 3G
#
#awk -F'[/ ]+' '{print $1 ;NF}' datacpu
#cat datacpu | awk -F'natur|/| ' '{print $1 ,NF}' > datacpu0
#
#  a= awk 'BEGIN{print $1}{if($1 != "natur.cuni.cz"){print "unincluded" }}' tmp
#  if [[ $a =~ $str ]]; then
#      echo "include"
#  else
#    echo "uninclude"
#  fi
#
#a= awk '{print $1}' dataNR;echo $a
#
#z=$(cat datacpu | awk -F 'natur' '{print $1}' |sed -n '2p') #sed 指定行
#echo ${z}natur.cuni.cz
#i=1
#a1=$(awk 'NR==${i}{PRINT $1}' datacpu)
#echo $a1
#
#str1="natur.cuni.cz"
#str2=awk '{print $1}' tmp
#if [[ $str1 =~ $str2 ]];then
#    echo "1"
#else
#    echo "2"
#fi
#
#i=2
#cat datacpu | awk -F '[/ ]+' '{print $5, NF}' |sed -n ${i}p