#!/bin/bash

LOG=result/log.csv
RES=r.rrd

[ -f $RES ] || rrdtool create $RES -b now-1d -s 300 DS:noise:GAUGE:1h:U:0.1 RRA:MAX:0:5m:7d RRA:AVERAGE:0.5:1h:30d

cat $LOG | cut -d ',' -f 1,4 | sed 's/,/:/' | tail -n +2 | while read data; do
  rrdtool update $RES $data
done


rrdtool graph day.png --imgformat PNG \
	DEF:avg=$RES:noise:AVERAGE \
	LINE1:avg#0000FF:"avg, dB"

