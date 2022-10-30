#!/bin/sh

cd /storage/camera-all
ls -rt | head -480 | xargs rm -v
cd /storage/camera
ls -rt | head -5 | xargs rm -v
