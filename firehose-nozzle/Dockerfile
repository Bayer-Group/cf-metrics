FROM ubuntu:trusty
MAINTAINER Mark Seidenstricker <@mjseid>

ENV GOPATH /go

ADD influxdb-firehose-nozzle /go/influxdb-firehose-nozzle

RUN apt-get update && apt-get install -y golang-go ca-certificates curl

VOLUME ["/data"]

ENTRYPOINT /go/influxdb-firehose-nozzle -config /go/influxdb-firehose-nozzle.json
