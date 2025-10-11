#!/bin/bash
count=0

while true; do
echo "Test-script running. Output $((count++))" >> test-log.txt
sleep 5
done