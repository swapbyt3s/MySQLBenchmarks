#!/bin/bash
# encoding: UTF-8

set -e

if [[ -z "${MYSQL_HOST}" ]]; then
  echo "The env var is not set: MYSQL_HOST"
fi

./insert.lua \
  --mysql-host=$MYSQL_HOST \
  --mysql-password=sbtest \
  prepare > /dev/null

./insert.lua \
  --mysql-host=$MYSQL_HOST \
  --mysql-password=sbtest \
  --threads=1 \
  --report-interval=1 \
  --max-time=1800 \
  run > insert.log

./select.lua \
  --mysql-host=$MYSQL_HOST \
  --mysql-password=sbtest \
  --threads=1 \
  --report-interval=1 \
  --max-time=1800 \
  run > select.log

./insert.lua \
  --mysql-host=$MYSQL_HOST \
  --mysql-password=sbtest \
  cleanup > /dev/null

cat insert.log | grep -Eo '[0-9]*;[0-9]*.[0-9]*' > insert.csv
cat select.log | grep -Eo '[0-9]*;[0-9]*.[0-9]*' > select.csv

./varchar.pg

rm insert{.log,.csv}
rm select{.log,.csv}
