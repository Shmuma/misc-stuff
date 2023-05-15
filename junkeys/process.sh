#!/bin/bash
#set -x

SRC=target
INT=10
logfile=result/log.csv
TGT=result

[ -f $logfile ] || echo "ts,date,time,level,file" > $logfile

while true; do
  for f in `find $SRC -type f | sort`; do
    echo "`date -Iseconds`: Processing $f"
    lev=$(sox $f -n stats 2>&1 | grep 'Pk lev' | sed 's/  */ /g' | cut -d ' ' -f 4 | sed 's/-//g')
    echo "Level $lev"
    name=$(basename $f +02:00.wav)
    ts=$(date -d "$name" +%s)
    n_date=$(echo $name | cut -d 'T' -f 1)
    n_time=$(echo $name | cut -d 'T' -f 2)
    t_name=$(echo $n_date-`echo $n_time | sed 's/:/_/g'`-$lev.mp3)
    echo "$ts,$n_date,$n_time,-$lev,$n_date/$t_name" >> $logfile
    ./put_file.sh $logfile $TGT log.csv
    ./record_noise.sh $ts -$lev
    ./make_charts.sh $n_date
    ./make_charts.sh $(date -d "$n_date -1 days" +"%Y-%m-%d")
    mkdir -p $TGT/$n_date
    echo "Compressing into $t_name"
    ffmpeg -v error -y -i file:$f $TGT/$n_date/$t_name && rm $f
    ./put_file.sh $TGT/$n_date/$t_name $TGT/$n_date $t_name
    echo "`date -Iseconds`: done"
  done
  sleep $INT
done
