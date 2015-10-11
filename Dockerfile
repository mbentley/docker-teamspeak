FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN (apt-get update && apt-get install -y wget)
RUN (wget http://dl.4players.de/ts/releases/3.0.11.4/teamspeak3-server_linux-amd64-3.0.11.4.tar.gz -O /tmp/teamspeak.tar.gz &&\
  tar zxf /tmp/teamspeak.tar.gz -C /opt &&\
  mv /opt/teamspeak3-server_* /opt/teamspeak &&\
  rm /tmp/teamspeak.tar.gz)
EXPOSE 9987/udp 10011 30033
VOLUME ["/opt/teamspeak"]
CMD ["/opt/teamspeak/ts3server_minimal_runscript.sh"]
