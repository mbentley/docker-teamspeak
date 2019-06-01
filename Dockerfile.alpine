FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV TS_DIRECTORY=/opt/teamspeak

# install the latest teamspeak
RUN apk add --no-cache bzip2 ca-certificates coreutils libstdc++ tini w3m &&\
  TS_SERVER_VER="$(w3m -dump https://www.teamspeak.com/downloads | grep -m 1 'Server 64-bit ' | awk '{print $NF}')" &&\
  wget https://files.teamspeak-services.com/releases/server/${TS_SERVER_VER}/teamspeak3-server_linux_alpine-${TS_SERVER_VER}.tar.bz2 -O /tmp/teamspeak.tar.bz2 &&\
  mkdir -p /opt &&\
  tar jxf /tmp/teamspeak.tar.bz2 -C /opt &&\
  mv /opt/teamspeak3-server_* ${TS_DIRECTORY} &&\
  rm /tmp/teamspeak.tar.bz2 &&\
  apk del bzip2 w3m

# create user, group, and set permissions
RUN adduser -u 503 -g 503 -h ${TS_DIRECTORY} -D teamspeak &&\
  mkdir /data &&\
  chown -R teamspeak:teamspeak ${TS_DIRECTORY} /data

COPY entrypoint.sh /entrypoint.sh

USER teamspeak
EXPOSE 9987/udp 10011 30033 41144
ENTRYPOINT ["/entrypoint.sh"]
