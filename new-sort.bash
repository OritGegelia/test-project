#!/bin/bash
count=0
while true; do {
  #строка номера вывода и текущей даты
  echo "Script running. Output $((count++)) $(date +%Y-%m %d\ %H:%M:%S): $(curl -s x.x.x.x/sensor)"

  #рекурсивная функция обхода дерева процессов.
  # Аргументы: s - идентификатор процесса
  # Локальные переменные: mem_sum - сумма памяти, child_list - список дочерних процессов,
  # i - индекс в цикле, n - количество дочерних процессов, child - текущий дочерний процесс
  function dfs(s,    mem_sum, child_list, i, n, child) {
    mem_sum += mem[s]

    if (s in children) {
        n = split(children[s], child_list, " ")
        for (i = 1; i <= n; i++) {
            child = child_list[i]
            dfs(child)
        }
    }
}

  #чтение данных о процессах, построение дерева процессов и вызов функции обхода
  ps -eo ppid,pid,%mem,cmd --no-headers | awk '{
      children[$1] = (children[$1] ? children[$1] : "") " " $2
      mem[$2] = $3
  } END {
      for (pid in children) {
          if (!(pid in visited)) {
              dfs(pid)
          }
      }
  }
  ' |awk -v mem_kb="$(grep MemTotal /proc/meminfo | awk '{print $2}')" '{mem[$1]+=$3; cmd[$1]=$4} END {for (NAME in mem) print NAME, cmd[NAME], int(mem[NAME]*mem_kb/100/1024)" MiB"}' OFS=',' | sort -t',' -k3,3rn
} > /var/log/sort.log 2>&1 
sleep 5
done