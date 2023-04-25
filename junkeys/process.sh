#!/bin/bash
#set -x

SRC=target
INT=10
logfile=log.csv
TGT=result

[ -f $logfile ] || echo "date,time,level,file" > $logfile

while true; do
  for f in `find $SRC -type f | sort`; do
    echo Processing $f
    lev=$(sox $f -n stats 2>&1 | grep 'Pk lev' | sed 's/  */ /g' | cut -d ' ' -f 4 | sed 's/-//g')
    echo Level $lev
    name=$(basename $f +02:00.wav)
    n_date=$(echo $name | cut -d 'T' -f 1)
    n_time=$(echo $name | cut -d 'T' -f 2)
    t_name=$(echo $n_date/$n_date-`echo $n_time | sed 's/:/_/g'`-$lev.mp3)
    echo "$n_date,$n_time,-$lev,$t_name" >> $logfile
    mkdir -p $TGT/$n_date
    echo Compressing into $t_name
    ffmpeg -v error -y -i file:$f $TGT/$t_name && rm $f
  done
  sleep $INT
done
