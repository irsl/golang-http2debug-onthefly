#!/bin/bash

# this version of the script is targeting the golang/x/net/http2 version of the http2 implementation,
# used by go-grpc apps for example.

set -e

PID=$1
if [ -z "$PID" ]; then
  echo "Usage: $0 pid"
  exit 1
fi

PACKAGE="${PACKAGE:-golang.org/x/net/http2}"

arr=()
no_threads="$(ls /proc/$PID/task | wc -w)"
for n in $(seq 1 $no_threads); do
  arr+=("-ex" "thread $n")
  arr+=("-ex" "print '$PACKAGE.VerboseLogs'=1")
  arr+=("-ex" "print '$PACKAGE.logFrameWrites'=1")
  arr+=("-ex" "print '$PACKAGE.logFrameReads'=1")
  arr+=("-ex" "print '$PACKAGE/h2c.http2VerboseLogs'=1") # note: this might not be in use, feel free to ignore the related errors
done

gdb -p $PID -ex "set confirm off" -ex "set pagination off" "${arr[@]}" -ex "quit"
