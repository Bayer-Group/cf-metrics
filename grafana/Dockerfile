FROM ubuntu:trusty

RUN apt-get update && apt-get -y install libfontconfig wget adduser openssl ca-certificates curl supervisor

RUN wget -O grafana_latest_amd64.deb https://grafanarel.s3.amazonaws.com/builds/grafana_4.1.0-1482230757beta1_amd64.deb
RUN dpkg -i grafana_latest_amd64.deb

EXPOSE 3000

VOLUME ["/usr/share/grafana/data"]

WORKDIR /usr/share/grafana

ADD dashboards/import_format/ /etc/grafana/dashboards/
ADD load.sh /etc/grafana/load.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
