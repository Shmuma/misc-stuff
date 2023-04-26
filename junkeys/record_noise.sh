#!/bin/bash


RRD=result/r.rrd

[ $# -ne 2 ] && echo "Usage $0 timestamp value" && exit 1

[ -f $RRD ] || rrdtool create $RES -b now-1d -s 300 DS:noise:GAUGE:1h:U:0.1 RRA:MAX:0:5m:7d RRA:AVERAGE:0.5:1h:30d

rrdtool update $RRD $1:$2

