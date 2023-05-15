#!/bin/bash

RRD=result/r.rrd
OUT_DIR=result/plots

[ $# -ne 1 ] && echo "Usage: $0 date" && exit 1

start_ts=`date -d "$1T12:00" +%s`
end_ts=$(($start_ts + 86400))
# 22:00 ruler
t1=$(($start_ts + 10*60*60))
# 6:00 ruler
t2=$(($t1 + 8*60*60))

res_dir=$OUT_DIR/`date +"%Y-%m"`

mkdir -p $res_dir

rrdtool graph $res_dir/$1.png --imgformat PNG \
	-s $start_ts -e $end_ts --title $1  \
	DEF:avg=$RRD:noise:AVERAGE \
	LINE1:avg#0000FF:"avg, dB" \
	VRULE:$t1#FF0000 VRULE:$t2#FF0000

./put_file.sh $res_dir/$1.png $res_dir $1.png
