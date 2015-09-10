#!/usr/bin/env bash

rm -f $1.wav
duration=`ffmpeg -i $1 2>&1 | grep Duration | awk '{print $2}' | tr -d , | sed 's/\...$//' | sed 's/^..://' | sed 's/:/./'`
cut=`echo "$duration > 0.45" | bc -l`
if [ $cut -eq 1 ]
then
  echo "Cutting and converting $1"
  ffmpeg -i $1 -ac 1 -ar 8000 -ss 30 -t 15 $1.wav 2>/dev/null
else
  echo "Converting $1"
  ffmpeg -i $1 -ac 1 -ar 8000 $1.wav 2>/dev/null
fi
