mbentley/teamspeak
==================

docker image for teamspeak
based off of debian:jessie

To pull this image:
`docker pull mbentley/teamspeak`

Example usage (no persistent storage; for testing only - you will lose your data when the container is removed):

`docker run -d --name teamspeak -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 mbentley/teamspeak`

Advanced usage with persistent storage:

1. Create necessary directories, files, and set permissions:
  * `mkdir -p /data/teamspeak`
  * `touch /data/teamspeak/ts3server.sqlitedb`
  * `chown -R 503:503 /data/teamspeak`

2. Start container:
    ```
    docker run -d --restart=always --name teamspeak \
      -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 \
      -v /data/teamspeak:/data \
      -v /data/teamspeak/ts3server.sqlitedb:/opt/teamspeak/ts3server.sqlitedb \
      mbentley/teamspeak \
      logpath=/data/logs/ \
      query_ip_whitelist=/data/query_ip_whitelist.txt \
      query_ip_blacklist=/data/query_ip_blacklist.txt
    ```

In order to get the credentials for your TS server, check the container logs as it will output the `serveradmin` password and your `ServerAdmin` privilege key.

For additional parameters, check the `(6) Commandline Parameters` section of the [TeamSpeak 3 Server Quickstart Guide](http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Quick%20Start.txt).
