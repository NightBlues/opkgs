#!/bin/sh

cd /storage/camera-all
ls -rt | head -480 | xargs rm -v
