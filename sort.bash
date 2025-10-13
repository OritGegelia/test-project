#!/bin/bash
exec > /var/log/sort.log 2>&1
count=0 
while true; do 
echo "Script running. Output $((count++)) $(date +%Y-%m-%d\ %H:%M:%S): $(curl -s x.x.x.x/sensor)"
ps -eo ppid,pid,%mem,command | awk -v mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')'{mem[$1]+=$3; cmd[$1]=$4} END {for (NAME in mem) print NAME, cmd[NAME], int(mem[NAME]*mem_kb/100/1024)" MiB"}' OFS=',' | sort -t',' -k3,3rn 
sleep 5 
done