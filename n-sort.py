#!/usr/bin/env python3

import sys

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
        print(f"{pid},{total_mem},{cmd}")

if __name__ == "__main__":
    n_sort()