#!/usr/bin/env bash

function stop {
	kill $(ps -C ts3server -o pid= | awk '{ print $1; }')
	exit
}

trap stop INT
trap stop TERM

test -d /data/files || mkdir -p /data/files && chown teamspeak:teamspeak /data/files
ln -sf /data/files $TS_DIRECTORY/files

test -d /data/logs || mkdir -p /data/logs && chown teamspeak:teamspeak /data/logs
ln -sf /data/logs $TS_DIRECTORY/logs

ln -sf /data/query_ip_whitelist.txt $TS_DIRECTORY/query_ip_whitelist.txt
ln -sf /data/query_ip_blacklist.txt $TS_DIRECTORY/query_ip_blacklist.txt
ln -sf /data/ts3server.ini $TS_DIRECTORY/ts3server.ini
ln -sf /data/ts3server.sqlitedb $TS_DIRECTORY/ts3server.sqlitedb
ln -sf /data/ts3server.sqlitedb-shm $TS_DIRECTORY/ts3server.sqlitedb-shm
ln -sf /data/ts3server.sqlitedb-wal $TS_DIRECTORY/ts3server.sqlitedb-wal

# licensekey exists but is not linked
if [ -f /data/licensekey.dat ] && [ ! -e $TS_DIRECTORY/licensekey.dat ]
then
	echo "Link licensekey.dat"
	ln -sf /data/licensekey.dat $TS_DIRECTORY/licensekey.dat
fi
# licensekey does not exist but is linked
if [ ! -f /data/licensekey.dat ] && [ -e $TS_DIRECTORY/licensekey.dat ]
then
	echo "Unlink licensekey.dat"
	rm $TS_DIRECTORY/licensekey.dat
fi

exec $TS_DIRECTORY/ts3server_minimal_runscript.sh $@ &
wait
