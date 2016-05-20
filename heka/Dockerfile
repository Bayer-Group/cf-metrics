FROM ubuntu:trusty 

MAINTAINER Mark Seidenstricker <@mjseid>

RUN apt-get update
RUN apt-get install -y git cmake mercurial golang-go wget dpkg
RUN wget -O heka.deb https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka_0.10.0_amd64.deb
RUN dpkg -i heka.deb 

ADD lua_filters/ /usr/share/heka/lua_filters/
ADD hekad.toml /etc/hekad/hekad.toml
ADD lua_encoders/ /usr/share/heka/lua_encoders/
ADD lua_modules/ /usr/share/heka/lua_modules/

CMD ["/usr/bin/hekad","--config=/etc/hekad/hekad.toml"]   

