#!/bin/bash

set -e

function stop {
  kill "$(ps -C ts3server -o pid= | awk '{ print $1; }')"
  exit
}

trap stop INT
trap stop TERM

# create directory for teamspeak files
test -d /data/files || mkdir -p /data/files && chown teamspeak:teamspeak /data/files

# create directory for teamspeak logs
test -d /data/logs || mkdir -p /data/logs && chown teamspeak:teamspeak /data/logs

# create symlinks for all files and directories in the persistent data directory
cd "${TS_DIRECTORY}"
for i in /data/*
do
  ln -sf "${i}"
done

# remove broken symlinks
find -L "${TS_DIRECTORY}" -type l -delete

# create symlinks for static files
STATIC_FILES=(
  query_ip_whitelist.txt
  query_ip_blacklist.txt
  ts3server.ini
  ts3server.sqlitedb
  ts3server.sqlitedb-shm
  ts3server.sqlitedb-wal
)
for i in "${STATIC_FILES[@]}"
do
  ln -sf /data/"${i}"
done

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
exec /tini -- ./ts3server "$@"
