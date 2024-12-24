#!/bin/bash

arch=$(uname -a)

cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

cpu_virtual=$(nproc)

memory=$(free -m | awk '/Mem/ {print $3 "/" $2 "MB   ""("$3/$2*100"%)"}')

disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

cpu=$(mpstat | tail -n 1 | awk '{printf "%.1f%%\n", 100 - $13}')

time=$(who -b | awk '{print $3"   " $4}')

lvm=$(if lsblk | awk '{print $6}' |grep -q 'lvm'; then echo "yes"; else echo "no"; fi)

tcp=$(netstat -at | grep ESTABLISHED |wc -l)

Network=$(hostname -I)
mac=$(ip a | grep "link/ether" | awk '{print $2}')

log=$(who | awk '{print $1}' | sort -u |wc -l)

sudo=$(grep -c 'COMMAND' /var/log/sudo/sudo.log)

wall "#Architecture: $arch
	#CPU physical : $cpu_physical
	#vCPU : $cpu_virtual
	#Memory Usage: $memory
	#Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	#CPU load: $cpu
	#Last boot:	$time
	#LVM use: $lvm
	#Connections TCP : $tcp ESTABLISHED
	#User log: $log
	#Network: IP $Network ($mac)
	#Sudo : $sudo
"
