#!/bin/bash
#cpu使用率
interval=3
cpu_num=$(cat /proc/stat | grep cpu[0-9] -c)
start_idle=()
start_total=()
cpu_rate=()

cpu_rate_file=/tmp/cpu_rate.log

if [ -f ${cpu_rate_file} ]; then
   cat /dev/null > ${cpu_rate_file}
   #mv ${cpu_rate_file} ${cpu_rate_file}.`date +%m_%d-%H_%M_%S`.bak
fi

#for((i=0;i<${cpu_num};i++))
#{
#    echo -n "cpu$i," >> ${cpu_rate_file}
#}
#echo -n "cpu" >> ${cpu_rate_file}
#echo "" >> ${cpu_rate_file}


for((i=0;i<${cpu_num};i++))
    {
        start=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
        start_idle[$i]=$(echo ${start} | awk '{print $4}')
        start_total[$i]=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
    }
    
sleep ${interval}

for((i=0;i<${cpu_num};i++))
    {
        end=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
        end_idle=$(echo ${end} | awk '{print $4}')
        end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
        idle=`expr ${end_idle} - ${start_idle[$i]}`
        total=`expr ${end_total} - ${start_total[$i]}`
        idle_normal=`expr ${idle} \* 100`
        cpu_usage=`expr ${idle_normal} / ${total}`
        cpu_rate[$i]=`expr 100 - ${cpu_usage}`
        echo "CPU$i:${cpu_rate[$i]}" >> ${cpu_rate_file}
    }

warn=$1

for((i=0;i<${cpu_num};i++))
    {
       rate=$(cat ${cpu_rate_file} |grep "CPU$i" |awk -F":" '{print $2}')
       if [ ${rate} -ge ${warn} ];then
           echo -n "cpu$i ${rate}% >= ${warn}%;"
           exit 1
       else
           echo -n "cpu$i,ok;" |grep "cpu$(expr ${cpu_num} - 1)" > /dev/null ;checkout=$?
           if [ ${checkout} -eq 0 ];then
               echo OK;
               exit 0
           fi
       fi
    }

