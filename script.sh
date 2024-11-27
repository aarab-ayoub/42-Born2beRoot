#!/bin/bash

arch=$(uname -a)

cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

cpu_virtual=$(grep "processor" /proc/cpuinfo | wc -l)

memory=$(free -m | awk '/Mem/ {print $3 "/" $2 "MB   ""("$3/$2*100"%)"}')

disk=$(df -h | awk 'NR==4 {print $3 "/" $2 "   ""("$5")"}')

cpu=

time=$(who -b | awk '{print $3"   " $4}')

log=$(who | wc -l)

wall "#Architecture: $arch
	#CPU physical : $cpu_physical
	#vCPU : $cpu_virtual
	#Memory Usage: $memory
	#Disk Usage: 
	#CPU load: 
	#Last boot:	$time
	#LVM use: 
	#Connections TCP : 
	#User log: 
	#Network: 
	#Sudo : 
"