FROM ubuntu

MAINTAINER Rik Ribbers

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-add-repository ppa:webupd8team/java

RUN apt-get update \
  && apt-get install -y default-jdk git build-essential vim wget unzip libsaxon-java maven


# add XTST for SI-UBL schematron validation
# default install is in $HOME/opt/XTST move to /opt instead
RUN git clone git://github.com/tjeb/xtst.git /usr/src/xtst \
  && cd /usr/src/xtst \
  && make \
  && make install \
  && mv ~/opt/XTST /opt/ \
  && rm -r /usr/src/xtst

# add UBL-1.2 XSD
RUN mkdir -p /tmp/ubl \
  && cd /tmp/ubl \
  && wget -q https://docs.oasis-open.org/ubl/os-UBL-2.1/UBL-2.1.zip \   
  && unzip /tmp/ubl/UBL-2.1.zip \
  && mv /tmp/ubl/xsd /opt \
  && rm -r /tmp/ubl


# clone the validation stuff
RUN git clone git://github.com/SimplerInvoicing/validation.git /usr/src/validation \
  && git clone git://github.com/SimplerInvoicing/testset.git /opt/testset \
  && mkdir /opt/si-ubl 

# build version 1.0; rename to proper versioning 1.0
RUN cd /usr/src/validation  \
  && git checkout refs/tags/v1.0.3 \
  && cp SI-UBL-INV-100.XSL /opt/si-ubl/SI-UBL-INV-1.0.xsl 

# build version 1.1; note this currently master
RUN cd /usr/src/validation  \
  && git checkout master \
  && ./convert_linux.sh SI-UBL-INV.SCH SI-UBL-INV-1.1.XSL \
  && cp SI-UBL-INV-1.1.XSL /opt/si-ubl/SI-UBL-INV-1.1.xsl 

# build version 2.1; note this currently branche master
# invoice
RUN cd /usr/src/validation  \
  && git checkout master \
  && JAVA_OPTS="-Xms3g -Xmx3g" ./convert_linux.sh SI-UBL-INV.SCH SI-UBL-INV-1.2.XSL \
  && cp SI-UBL-INV-1.2.XSL /opt/si-ubl/SI-UBL-INV-1.2.xsl 

# purchase order
RUN cd /usr/src/validation  \
  && git checkout master \
  && JAVA_OPTS="-Xms3g -Xmx3g" ./convert_linux.sh SI-UBL-PO.SCH SI-UBL-PO-1.2.XSL \
  && cp SI-UBL-PO-1.2.XSL /opt/si-ubl/SI-UBL-PO-1.2.xsl 


# en16391 java tools
RUN git clone https://github.com/CenPC434/java-tools.git /usr/src/java-tools \
  && mkdir -p /opt/java-tools \
  && cd /usr/src/java-tools \
  && mvn install \
  && mv /usr/src/java-tools/en16931-xml-validator/target/en16931-xml-validator-0.2.0-SNAPSHOT-jar-with-dependencies.jar /opt/java-tools/en16931-xml-validator.jar


ADD bin/validation.sh /opt/si-ubl/validation.sh
ADD bin/validate-all.sh /opt/si-ubl/validate-all.sh
ADD participant-exists.py /usr/bin/participant-exists.py 
ADD sml-lookup.py /usr/bin/participant-exists.py 

ADD SSLPoke.java /opt/SSLPoke.java
RUN cd /opt \
  && javac SSLPoke.java



