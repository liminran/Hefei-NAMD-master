#!/bin/bash
qstat|
grep  "[1-9]\+"|     #筛选出jobid，也可以根据特定的任务名筛选
cut -d ' ' -f2|             #-d以空格为分隔符，-f 指定区域，，获取第二列jobid编号；
xargs -I {} echo 'qstat -j {}'|   #将jobid一个一个的传给echo，其中 -I  {}参数，这个{}就是xargs要传递的名字
sh|                  #执行
sed -n '/cwd\|job_name/p'     #筛选出关注的信息，其中多条件匹配中间用  \|  分割两个匹配