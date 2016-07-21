#!/bin/bash
#richard 06.23
file="/usr/local/nagios/etc/objects/servers/haitun/"
for line in `ls $file`
do
        _ip=`echo $line |cut -d "-" -f 2 |cut -d "." -f 1 |sed 's/\_/\./g'`
        echo "define service{
        use                             local-service         ; Name of service template to use
        host_name                       ${_ip} 
        service_description             check_used_mem
        check_command                   check_nrpe!check_used_mem
        notifications_enabled           0
        }" >>$file$line
done
