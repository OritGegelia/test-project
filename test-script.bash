#!/bin/bash
count=0

while true; do
echo "Test-script running. $(date +%Y-%m-%d\ %H:%M:%S): `curl -s x.x.x.x/sensor` Output $((count++))" > test-log.txt
sleep 5
done