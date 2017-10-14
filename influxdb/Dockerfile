FROM ubuntu:trusty 
MAINTAINER mjseid 
ENV INFLUXDB_VERSION 1.3.6

RUN apt-get update && apt-get install -y curl openssh-client awscli 
RUN curl -s -o /tmp/influxdb_latest_amd64.deb https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
  dpkg -i /tmp/influxdb_latest_amd64.deb && \
  rm /tmp/influxdb_latest_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

ADD influxdb.config /etc/influxdb/influxdb.config
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV PRE_CREATE_DB **None**

EXPOSE 8083 8084 8086

VOLUME ["/data"]

CMD ["/run.sh"]
