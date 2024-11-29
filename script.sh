#!/bin/bash

arch=$(uname -a)

cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

cpu_virtual=$(grep "processor" /proc/cpuinfo | wc -l)

memory=$(free -m | awk '/Mem/ {print $3 "/" $2 "MB   ""("$3/$2*100"%)"}')

disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)

time=$(who -b | awk '{print $3"   " $4}')

lvm=$(if sudo lvscan | grep -q 'ACTIVE'; then echo "yes"; else echo "no"; fi)

tcp=$(ss -t state established | wc -l)

Network=$(hostname -I)
mac=$(ip a | grep "link/ether" | awk '{print $2}')

log=$(who | wc -l)

sudo=$(grep -c 'COMMAND' /var/log/sudo/sudo.log)

wall "#Architecture: $arch
	#CPU physical : $cpu_physical
	#vCPU : $cpu_virtual
	#Memory Usage: $memory
	#Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	#CPU load: $cpu_fin%
	#Last boot:	$time
	#LVM use: $lvm
	#Connections TCP : $tcp ESTABLISHED
	#User log: $log
	#Network: IP $Network ($mac)
	#Sudo : $sudo
"