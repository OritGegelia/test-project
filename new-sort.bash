#!/bin/bash
count=0
n=500
 
  while true; do {
    # данные о памяти
    total_mem=$(free -m | grep Mem | awk '{print $2}')
    used_mem=$(free -m | grep Mem | awk '{print $3}')
    available_mem=$((total_mem - used_mem))

    # условие
    if [ $available_mem -gt $n ]; then
        status="памяти достаточно"
    else
        status="Памяти недостаточно"
    fi

    # строка номера вывода и текущей даты и информоация о MEMORY
    echo "Script running. Output $((count++)) $(date '+%Y-%m-%d %H:%M:%S'): $(curl -s x.x.x.x/sensor)"
    echo "Total system memory: $(free -h | grep Mem | awk '{print $2}')"
    echo "System memory usage: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    echo "Status: $status"
    
    # чтение данных о процессах, построение дерева процессов и вызов функции обхода
    sort_result=$(ps -eo ppid,pid,%mem,cmd --no-headers | python3 n-sort.py)
    echo "PPID, MEMORY, COMMAND"
    echo "$sort_result"
  } > ~/var/log/neww-sort.log
  sleep 5  
  done