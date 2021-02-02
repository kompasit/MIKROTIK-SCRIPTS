#!/bin/bash

HOST=192.168.77.1
PORT=3022
USER=admin
DEST="/home/oleg/tmp"

SSH="/usr/bin/ssh"

CMD='$SSH -p $PORT $USER@$HOST ":foreach i in=[file find name~\"backup\\$\"] do={:put [file get \$i name]}"'

# Delimiter for 'for' is \n
IFS=$'\n'

#$SSH -p $PORT $USER@$HOST "system backup save"

for f in `eval $CMD`
do
    echo $f
    SCPCMD="scp -P $PORT $USER@$HOST:/$f $DEST"
    echo $SCPCMD
    exec $SCPCMD
done

$SSH -p $PORT $USER@$HOST "file remove [file find name~\"backup\\$\"]"
