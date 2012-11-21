#!/bin/sh

ACK="/usr/local/bin/ack -oh"

find . -name '*.h' -or -name '*.m' -print0 | xargs -0 $ACK "(?<=L\(@)[^)]*|(?<=LU\(@)[^)]*|(?<=LF\(@)[^,]*" | sort | uniq > /tmp/keys_in_code.txt
$ACK '^"[^"]*"' "$1" | sort > /tmp/keys_in_file.txt
diff -u /tmp/keys_in_code.txt /tmp/keys_in_file.txt
