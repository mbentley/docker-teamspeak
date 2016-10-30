#!/usr/bin/env bash

set -e

function stop {
	kill $(ps -C ts3server -o pid= | awk '{ print $1; }')
	exit
}

trap stop INT
trap stop TERM

# create directory for teamspeak files
test -d /data/files || mkdir -p /data/files && chown teamspeak:teamspeak /data/files

# create directory for teamspeak logs
test -d /data/logs || mkdir -p /data/logs && chown teamspeak:teamspeak /data/logs

# create default files
touch /data/query_ip_whitelist.txt /data/query_ip_blacklist.txt /data/ts3server.ini /data/ts3server.sqlitedb /data/ts3server.sqlitedb-shm /data/ts3server.sqlitedb-wal

# create symlinks for all files and directories in the persistent data directory
cd $TS_DIRECTORY
for i in $(ls /data)
do
  ln -sf /data/${i}
done

# remove broken symlinks
find -L $TS_DIRECTORY -type l -delete

exec $TS_DIRECTORY/ts3server_minimal_runscript.sh $@ &
wait
