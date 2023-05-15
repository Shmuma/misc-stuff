#!/bin/bash

[ $# -ne 3 ] && echo "Usage $0 local remote_dir remote_name" && exit 1

SHARE="//ds2/shared/"
BASE="noise"

smbclient -U " "%" " -c "recurse; mkdir $BASE/$2" $SHARE
smbclient -U " "%" " -c "put $1 $BASE/$2/$3" $SHARE

