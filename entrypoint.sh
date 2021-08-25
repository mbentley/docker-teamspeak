#!/bin/sh

set -e

# set default variables
PUID="${PUID:-503}"
PGID="${PGID:-503}"
TS_DIRECTORY="${TS_DIRECTORY:-}"

# determine which OS we are running so we can create the user & group using the right tools
case "$(. /etc/os-release; echo "${ID}")" in
  alpine)
    # set the su program
    SU_APP="su-exec"

    if id -u teamspeak > /dev/null 2>&1
    then
      echo "INFO: User exists; skipping creation"
    else
      echo "INFO: User doesn't exist; creating..."
      adduser -u "${PUID}" -g "${PGID}" -h "${TS_DIRECTORY}" -D teamspeak
    fi
    ;;
  debian)
    # set the su program
    SU_APP="gosu"

    if id -u teamspeak > /dev/null 2>&1
    then
      echo "INFO: User exists; skipping creation"
    else
      echo "INFO: User doesn't exist; creating..."
      groupadd -g "${PGID}" teamspeak
      useradd -u "${PUID}" -g "${PGID}" -d "${TS_DIRECTORY}" teamspeak
    fi
    ;;
  *)
    echo "ERROR: unsupported OS detected"
    exit 1
    ;;
esac

# create data directory, if needed
test -d /data || mkdir /data && chown -R teamspeak:teamspeak /data

# set user/group ownership on the TS_DIRECTORY directory
chown -R teamspeak:teamspeak "${TS_DIRECTORY}"

# create directory for teamspeak files
test -d /data/files || mkdir -p /data/files && chown teamspeak:teamspeak /data/files

# create directory for teamspeak logs
test -d /data/logs || mkdir -p /data/logs && chown teamspeak:teamspeak /data/logs

# create symlinks for all files and directories in the persistent data directory
cd "${TS_DIRECTORY}"
for i in /data/*
do
  ln -sf "${i}" .
done

# remove broken symlinks
find -L "${TS_DIRECTORY}" -type l -delete

# create symlinks for static files
STATIC_FILES="query_ip_whitelist.txt query_ip_blacklist.txt ts3server.ini ts3server.sqlitedb ts3server.sqlitedb-shm ts3server.sqlitedb-wal .ts3server_license_accepted"

for i in ${STATIC_FILES}
do
  ln -sf /data/"${i}" .
done

# check to see if license agreement method has been passed (this doesn't validate the license agreement acceptance; just a basic check)
if [ -f "${TS_DIRECTORY}/.ts3server_license_accepted" ] || [ "$(echo "$*" | grep -q "license_accepted=1"; echo $?)" = "0" ] || [ "${TS3SERVER_LICENSE}" = "accept" ]
then
  echo "Found a license agreement method; launching TeamSpeak"
else
  echo "Warning: license agreement method hasn't been passed; see the README (https://github.com/mbentley/docker-teamspeak#license-agreement) for how to do so with this Docker image"
  echo "Note: if you're running TeamSpeak < 3.1.0; you can safely ignore this message"; echo
fi

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
exec "${SU_APP}" teamspeak:teamspeak tini -- ./ts3server "$@"
