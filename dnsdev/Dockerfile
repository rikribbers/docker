FROM rikribbers/erldev

MAINTAINER Rik Ribbers <rik.ribbers@gmail.nl>

RUN apt-get update \
    && apt-get -y install software-properties-common python-software-properties \ 
    && add-apt-repository ppa:ubuntu-lxc/lxd-stable \
    && apt-get update \
    && apt-get -y install golang libunbound-dev dnsutils unbound

RUN mkdir -p /go/root \ 
    && mkdir -p /go/path\ 
    && mkdir -p /go/path/src/spark \
    && mkdir -p /go/path/bin \ 
    && mkdir -p /var/log/unbound

RUN cd /tmp \
    && git clone https://github.com/SIDN/spark.git \
    && mv /tmp/spark/spark.go /go/path/src/spark/main.go

ADD unbound.conf /etc/unbound/unbound.conf

RUN chown unbound:unbound /var/log/unbound
ENV GOROOT=/usr/lib/go-1.6
ENV GOPATH=/go/path
ENV GOSRC=/go/path/src

RUN cd $GOPATH \
    && go get github.com/miekg/dns \
    && go get github.com/miekg/unbound \
    && go build spark \
    && mv $GOPATH/spark /usr/local/bin