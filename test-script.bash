#!/bin/bash
count=0

while true; do
echo "Test-script running. $(date +%Y-%m-%d\ %H:%M:%S): $(curl -s x.x.x.x/sensor) Output $((count++))" > /var/log/test-script.log
sleep 5
done