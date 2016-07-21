#!/bin/bash
#by richard

deny='#sshd:all:deny'

de=`cat /etc/hosts.deny |grep '^#'|grep "sshd:all:deny"`
if [ x${de} != x${deny} ];then
	a=1
else
        echo "hosts_deny is error"
fi


ips=(114.215.200.4 182.92.76.208 120.24.212.117)

test=`cat /etc/hosts.allow |awk -F ':' '{print $2}' |awk '/./'`
connt=`cat /etc/hosts.allow |awk -F ':' '{print $2}' |awk '/./'|wc -l`
x=0
if [[ $connt -ne 3 ]];then
	echo "hosts_alllow is some error"
	exit 2
else
	for i in ${test[@]}; do
	        for j in ${ips[@]}; do
			if [[ $i = $j ]]; then
                	        x=`expr $x + 1`
                	fi
        	done
	done
fi

if [[ $a -eq 1 && $x -eq 3 ]];then
	echo "deny and allow is ok " $test |sed 'N;s/\n//g'
	exit 0
else
	echo 'error!chack deny and allow'
	exit 2
fi