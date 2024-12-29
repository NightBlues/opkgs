#!/bin/sh

echo $HOSTNAME
df -h /storage/
EARLY_VIDEO_DATE=$(ls -rt --full-time /storage/camera-all/ | head -1 | sed 's/.* \(\d\d\d\d-\d\d-\d\d\) .*/\1/g')
PER_DAY_COUNT=$(ls -rt --full-time /storage/camera-all/ | grep $EARLY_VIDEO_DATE | wc -l)
echo "Earlyest video date: $EARLY_VIDEO_DATE ($PER_DAY_COUNT)"
echo -n "temperature "
cat /sys/class/thermal/thermal_zone0/temp
echo -n "motion-all "
/etc/init.d/motion-all status
echo -n "motion-detect"
/etc/init.d/motion-detect status
uptime

