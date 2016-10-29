#!/usr/bin/env bash

function stop {
	kill $(ps -C ts3server -o pid= | awk '{ print $1; }')
	exit
}

trap stop INT
trap stop TERM

exec /opt/teamspeak/ts3server_minimal_runscript.sh $@ &
wait
