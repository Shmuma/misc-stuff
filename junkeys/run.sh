#!/bin/bash

set -x

INT=300
#INT=10
TGT=target

mkdir -p $TGT
echo Preparation to get round interval after start...
to_sleep=$(echo "$INT - (`date +%s` % $INT)" | bc)
sleep $to_sleep
 
while true; do
  name=`date -Iseconds`
  echo $name

  arecord --format=S16_LE --device="default" -r 44100 -d $INT $name.wav
  mv $name.wav $TGT
done
