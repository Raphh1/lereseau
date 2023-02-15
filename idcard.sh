#!/bin/bash

echo "Machine name: $(hostnamectl hostname)"
echo "OS: $(cat /etc/redhat-release) and kernel version is $(uname -v)"
echo "IP: $(hostname -I | cut -d ' ' -f1)"
echo "RAM: $(grep MemFree /proc/meminfo | tr -s ' ' | cut -d' ' -f 2) KB memory available on $(grep MemTotal /proc/meminfo | tr -s ' ' | cut -d' ' -f 2) KB total memory"
echo "Disk: $(df | grep sda | tr -s ' ' | cut -d' ' -f4) KB space left"
echo "Top 5 processes by RAM usage :"
for i in $(ps aux | sort -rnk 4 | head -5 | tr -s ' ' | cut -d' ' -f11)
do
    echo "- ${i}"
done
echo "Listening ports: "
ss_output="$(ss -altpnu4H)"
while read fut; do
    port_type="$(echo ${fut} | cut -d' ' -f1)"
    port_number="$(echo ${fut} | cut -d' ' -f5 | cut -d':' -f2)"
    program="$(echo ${fut} | cut -d' ' -f7 |  cut -d'(' -f3 | cut -d',' -f1 | cut -d'"' -f2)"
    echo "  - $port_type $port_number $program"
done <<< "$ss_output"
curl https://cataas.com/cat -o cat.png &> /dev/null
echo "Here is your random cat: ./cat.png"