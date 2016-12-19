FROM ubuntu

MAINTAINER Rik Ribbers <rik.ribbers@gmail.nl>

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget git unzip vim

RUN cd /tmp \
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update && apt-get -y install erlang erlang-base-hipe build-essential \
    && rm /tmp/erlang-solutions_1.0_all.deb

# Install rebar 3
# example from: https://github.com/c0b/docker-erlang-otp
ENV REBAR3_VERSION=3.2.0

RUN git clone --depth 50 --branch $REBAR3_VERSION --single-branch git://github.com/erlang/rebar3.git /usr/src/rebar3-src \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
	&& rm -rf /usr/src/rebar3-src

# Install QuickCheck mini
ENV EQC_VERSION=2.01.0
RUN mkdir -p /tmp/eqc \
    && cd /tmp/eqc \
    && wget http://www.quviq.com/wp-content/uploads/2015/09/eqcmini-$EQC_VERSION.zip  \
    && unzip eqcmini-$EQC_VERSION.zip \
    && erl -detached -s eqc_install install \
    && sleep 5 \
    && rm -r /tmp/eqc
