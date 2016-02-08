mbentley/teamspeak
==================

docker image for teamspeak
based off of debian:jessie

To pull this image:
`docker pull mbentley/teamspeak`

Example usage:
`docker run -d net=host --name teamspeak mbentley/teamspeak`

Advanced usage with persistent storage:

1. Create necessary directories, files, and set permissions:
  * `mkdir -p /data/teamspeak`
  * `touch /data/teamspeak/ts3server.sqlitedb`
  * `chown -R 503:503 /data/teamspeak`

2. Start container:
  * `docker run -d --restart=always --net=host --name teamspeak -v /data/teamspeak:/data -v /data/teamspeak/ts3server.sqlitedb:/opt/teamspeak/ts3server.sqlitedb mbentley/teamspeak logpath=/data/logs/ query_ip_whitelist=/data/query_ip_whitelist.txt query_ip_blacklist=/data/query_ip_blacklist.txt`
