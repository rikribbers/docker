FROM ubuntu

MAINTAINER Rik Ribbers

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-add-repository ppa:webupd8team/java

RUN apt-get update \
  && apt-get install -y maven default-jdk maven  mysql-client

