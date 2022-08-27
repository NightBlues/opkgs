#!/bin/sh

df -h /storage/
echo -n "temperature "
cat /sys/class/thermal/thermal_zone0/temp
echo -n "motion-all "
/etc/init.d/motion-all status
uptime
