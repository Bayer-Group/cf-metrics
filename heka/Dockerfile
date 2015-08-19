FROM ubuntu:trusty 

MAINTAINER Mark Seidenstricker <mjseid@monsanto.com>

RUN apt-get update
RUN apt-get install -y git cmake mercurial golang-go wget dpkg
#RUN wget -O heka.deb https://github.com/mozilla-services/heka/releases/download/v0.9.2/heka_0.9.2_amd64.deb
RUN wget -O heka.deb https://github.com/mozilla-services/heka/releases/download/v0.10.0b1/heka_0.10.0b1_amd64.deb
RUN dpkg -i heka.deb 

ADD lua_filters/ /usr/share/heka/lua_filters/
ADD hekad.toml /etc/hekad/hekad.toml
ADD lua_encoders/ /usr/share/heka/lua_encoders/
ADD lua_modules/ /usr/share/heka/lua_modules/

CMD ["/usr/bin/hekad","--config=/etc/hekad/hekad.toml"]   

