#!/bin/bash

set -e

PID=$1
KEY="$2"
VALUE="$3"
if [ -z "$PID" ] || [ -z "$VALUE" ]; then
  echo "Usage: $0 pid key value"
  exit 1
fi

arr=()
no_threads="$(ls /proc/$PID/task | wc -w)"
for n in $(seq 1 $no_threads); do
  arr+=("-ex" "thread $n")
  arr+=("-ex" "call __sentenv(\"$KEY\", \"$VALUE\", 1)")
done

gdb -p $PID -ex "set confirm off" -ex "set pagination off" "${arr[@]}" -ex "quit" < /dev/null

