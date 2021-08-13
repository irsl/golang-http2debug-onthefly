#!/bin/bash

set -e

PID=$1
if [ -z "$PID" ]; then
  echo "Usage: $0 pid"
  exit 1
fi

arr=()
no_threads="$(ls /proc/$PID/task | wc -w)"
for n in $(seq 1 $no_threads); do
  arr+=("-ex" "thread $n")
  arr+=("-ex" "print 'net/http.http2VerboseLogs'=1")
  arr+=("-ex" "print 'net/http.http2logFrameReads'=1")
  arr+=("-ex" "print 'net/http.http2logFrameWrites'=1")
done

gdb -p $PID ex "set confirm off" -ex "set pagination off" "${arr[@]}" -ex "quit" </dev/null

