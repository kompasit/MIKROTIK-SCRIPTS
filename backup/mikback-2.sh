#!/bin/bash

#set -x
#set -v

HOST=192.168.57.1
PORT=3022
USER=admin
DEST="/home/oleh/tmp"

SSH="/usr/bin/ssh"

#CMD="$SSH -p $PORT $USER@$HOST \":foreach i in=[file find name~\"backup\\$\"] do={:put [file get \$i name]}\""
CMD='":foreach i in=[file find name~\"backup\\$\"] do={:put [file get \$i name]}"'
CMD="$SSH -p $PORT $USER@$HOST "${CMD}

FILE_LIST=`eval $CMD`

#echo
echo "$FILE_LIST" > fl.txt
#echo

$SSH -p $PORT $USER@$HOST "system backup save"


# Delimiter for 'for' is \n
IFS=$'\n\r'


for f in `cat fl.txt`
do
    echo "***" $f
    scp -P  $PORT $USER@$HOST:$f $DEST
#    echo ${SCP_CMD}
#    exec $SCPCMD
done

$SSH -p $PORT $USER@$HOST "file remove [find name~\"backup\\$\"]"
