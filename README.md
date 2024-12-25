
# **Born2beRoot Project**

## **Overview**
The **Born2beRoot** project is a deep dive into Linux system administration, focusing on building a secure, performant, and robust virtual machine. This project introduces advanced concepts such as virtualization, partitioning, logical volume management (LVM), network security, and automated system monitoring. The goal was to create a fully operational server adhering to strict security and configuration guidelines while demonstrating mastery over key Linux tools and services.

---

## **Key Features**

1. **Secure Server Configuration**:
   - Custom SSH setup on port 4242 with root login disabled.
   - Implementation of strong password policies to enforce security best practices.
   - Use of **UFW** firewall to manage and restrict network traffic.

2. **Advanced Partitioning**:
   - Disk partitioning with **Logical Volume Manager (LVM)** for flexible and secure storage.
   - Encrypted partitions to ensure data confidentiality and integrity.

3. **Monitoring Script**:
   - A dynamic Bash script that provides real-time insights into the server's performance, resource usage, and network activity.
   - Configured to run at regular intervals using `cron`.

4. **Bonus Features**:
   - Additional services and advanced configurations to demonstrate extended system capabilities (e.g., WordPress setup, custom partitions).

---

## **Monitoring Script Details**

### **Script Features**
The `monitoring.sh` script is designed to display comprehensive system information at a glance. Below are the metrics it collects:

- **Architecture**: The system's architecture and kernel version.
- **CPU Details**: Physical and virtual CPU counts, along with real-time CPU load.
- **Memory Usage**: Current and total memory usage with percentage.
- **Disk Usage**: Total, used, and available disk space with percentage.
- **Last Boot Time**: Date and time of the last system reboot.
- **LVM Usage**: Whether LVM is being utilized.
- **TCP Connections**: Number of established TCP connections.
- **Logged-in Users**: Count of unique users currently logged in.
- **Network Information**: IP and MAC addresses of the server.
- **Sudo Commands**: Number of sudo commands executed.

### **Script Commands and Functions**

Here’s a breakdown of what each part of the script does:

1. **System Architecture**:
   ```bash
   arch=$(uname -a)
   ```
   Retrieves system architecture and kernel information.
2. **CPU Information**:
	*Physical CPUs*: 
	```bash
	cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
   ```
   *Virtual CPUs (threads)*: 
	```bash
	cpu_virtual=$(nproc)
   ```
3. **Memory Usage**:
	```bash
	memory=$(free -m | awk '/Mem/ {print $3 "/" $2 "MB ""("$3/$2*100"%)"}')
   ```
4. **Disk Usage**:
	*Total Disk Space*: 
	```bash
	disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
   ```
   *Used Disk Space*: 
	```bash
	disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
   ```
     *Percentage Used*: 
	```bash
	disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')
   ```
5. **CPU Load**:
	```bash
	cpu=$(mpstat | tail -n 1 | awk '{printf "%.1f%%\n", 100 - $13}')
   ```
6. **Last Boot Time**:
	```bash
	time=$(who -b | awk '{print $3" " $4}')
   ```
7. **LVM Usage**:
	```bash
	lvm=$(if lsblk | awk '{print $6}' |grep -q 'lvm'; then echo "yes"; else echo "no"; fi)
   ```
8. **TCP Connections**:
	```bash
	tcp=$(netstat -at | grep ESTABLISHED | wc -l)
   ```
9. **Network Information**:
	 *IP Address*: 
	```bash
	Network=$(hostname -I)
   ```
   *MAC Address*: 
	```bash
	mac=$(ip a | grep "link/ether" | awk '{print $2}')
   ```
 
10. **Logged-in Users**:
	````bash
	log=$(who | awk '{print $1}' | sort -u | wc -l) ```
11. **Sudo Commands**:
	```bash
	sudo=$(grep -c 'COMMAND' /var/log/sudo/sudo.log)`

### **Output Metrics**:
```bash
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
```
## **Installation Instructions**

### **Clone the Repository**:
```bash
git clone https://github.com/your_username/born2beroot.git
cd born2beroot
```
### **Run the Monitoring Script**:
**Make the script executable**:
```bash
chmod +x monitoring.sh
```
**Execute the script**:
```bash
./monitoring.sh
```
### **Set Up Cron Job (Optional)**:
To automate the script to run every 10 minutes:
```bash
crontab -e
```
Add this line:
```bash
*/10 * * * * /path/to/monitoring.sh
```
**Example Script Output**
```bash
Broadcast message from root@server (Sun Jan 1 12:00:00 2024):
#Architecture: Linux server 5.15.0-73-generic x86_64 GNU/Linux
#CPU physical : 2
#vCPU : 4
#Memory Usage: 2048/4096MB (50%)
#Disk Usage: 10Gb/50Gb (20%)
#CPU load: 15.3%
#Last boot:   2024-01-01 11:30
#LVM use: yes
#Connections TCP : 5 ESTABLISHED
#User log: 1
#Network: IP 192.168.0.101 (00:1A:2B:3C:4D:5E)
#Sudo : 25
```

## **Author**

-   **Name**: Aarab Ayoub
-   **Email**: ayaarab@student.1337.ma
-   **GitHub**: [aarab-ayoub](https://github.com/aarab-ayoub)
