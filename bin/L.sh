#!/bin/sh

ACK="/usr/local/bin/ack"

if [ ! -e "$ACK" ]; then
    echo "Cannot find $ACK"
    exit 1
fi

find . -name '*.h' -or -name '*.m' -print0 | xargs -0 $ACK -oh "(?<=L\(@)[^)]*|(?<=LU\(@)[^)]*|(?<=LF\(@)[^,]*" | sort | uniq > /tmp/keys_in_code.txt
$ACK -oh '^"[^"]*"' "$1" | sort > /tmp/keys_in_file.txt

! (diff -u /tmp/keys_in_code.txt /tmp/keys_in_file.txt | grep -E '^-"')