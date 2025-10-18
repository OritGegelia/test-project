#!/usr/bin/env python3

import sys
import subprocess

def get_memory():
    try:
        result = subprocess.run(['grep', 'MemTotal', '/proc/meminfo'], capture_output=True, text=True, check=True)
        mem_total_kb = int(result.stdout.split()[1])
    except Exception as e:
        mem_total_kb = None
    return mem_total_kb

# Рекурсивная функция для суммирования памяти процесса и его потомков
def dfs(pid, tree, mem_map):
    total = mem_map.get(pid, 0)
    for child in tree.get(pid, []):
        total += dfs(child, tree, mem_map)
    return total

# Основная функция для чтения входных данных и вывода результатов
def n_sort():
    tree = {}
    mem_map = {}
    command_map = {}
    for line in sys.stdin:
        ppid, pid, mem, *cmd = line.strip().split()
        tree.setdefault(ppid, []).append(pid)
        mem_map[pid] = float(mem)
        command_map[pid] = cmd
    result = []
    for pid in tree.get("0", []):
        total_mem = dfs(pid, tree, mem_map)
        result.append((pid, total_mem, command_map.get(pid, "")))
    result.sort(key=lambda x: x[1], reverse=True)
    for pid, total_mem, cmd in result:
        mem_in_mib = int(total_mem * get_memory() / 100 / 1024) if get_memory() else 0
        total_mem = f"{mem_in_mib} MiB"
        print(f"{pid}, {cmd}, {total_mem}")

if __name__ == "__main__":
    n_sort()