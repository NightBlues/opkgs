#!/bin/sh

cd /storage/camera-all
EARLY_VIDEO_DATE=$(ls -rt --full-time /storage/camera-all/ | head -1 | sed 's/.* \(\d\d\d\d-\d\d-\d\d\) .*/\1/g')
PER_DAY_COUNT=$(ls -rt --full-time /storage/camera-all/ | grep $EARLY_VIDEO_DATE | wc -l)
echo "PER_DAY_COUNT=$PER_DAY_COUNT"
ls -rt | head -$PER_DAY_COUNT | xargs rm -v
cd /storage/camera
ls -rt | head -80 | xargs rm -v

