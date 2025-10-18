#!/bin/bash
count=0
while true; do {
  #строка номера вывода и текущей даты
  echo "Script running. Output $((count++)) $(date +%Y-%m %d\ %H:%M:%S): $(curl -s x.x.x.x/sensor)"

  #чтение данных о процессах, построение дерева процессов и вызов функции обхода
  sort_result=$(ps -eo ppid,pid,%mem,cmd --no-headers | python3 n-sort.py)

  echo "$sort_result"
  

} > /var/log/new-sort.log 2>&1 
sleep 5
done