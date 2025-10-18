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

def dfs(pid, tree, mem_map):
    total = mem_map.get(pid, 0.0)
    for child in tree.get(pid, []):
        total += dfs(child, tree, mem_map)
    return total

def n_sort():
    tree = {}          
    mem_map = {}       
    cmd_map = {}       
    pid_set = set()    

    for line in sys.stdin:
        parts = line.strip().split(None, 3)
        if len(parts) < 3:
            continue
        ppid_s, pid_s, mem_s = parts[0], parts[1], parts[2]
        cmd = parts[3] if len(parts) > 3 else ""
        try:
            ppid = int(ppid_s)
            pid = int(pid_s)
            mem = float(mem_s)
        except ValueError:
            continue
        tree.setdefault(ppid, []).append(pid)
        mem_map[pid] = mem
        cmd_map[pid] = cmd
        pid_set.add(pid)

    root_ppids = [ppid for ppid in tree.keys() if ppid not in pid_set]

    if not root_ppids:
        root_ppids = [0]

    mem_total_kb = get_memory()
    results = []

    for root_ppid in root_ppids:
        for pid in tree.get(root_ppid, []):
            cmd = cmd_map.get(pid, "")
            total_pct = dfs(pid, tree, mem_map)
            total_mib = (total_pct * mem_total_kb / 100 / 1024) if mem_total_kb else 0
            results.append((pid, total_mib, cmd))

    # Вывод
    for pid, mib, cmd in results:
        print(f"{pid:>5}  {mib:8.1f} MiB {cmd}")

if __name__ == "__main__":
    n_sort()
