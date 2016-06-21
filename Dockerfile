FROM registry.access.redhat.com/rhel7.2
MAINTAINER GlenM gmillard@redhat

LABEL Name rhel7/crate
LABEL Vendor Crate.io
LABEL Version 0.49.1
LABEL Release OSS

RUN yum clean all; \
rpm --rebuilddb; \
yum install -y curl which tar sudo openssh-server openssh-clients rsync wget
RUN yum -y install bash

RUN yum -y install java-1.8.0-openjdk

ENV CRATE_VERSION 0.49.1

RUN mkdir /crate && \
wget -nv -O - "https://cdn.crate.io/downloads/releases/crate-$CRATE_VERSION.tar.gz" \
| tar -xzC /crate --strip-components=1

#ENV PATH /crate/bin:$PATH

VOLUME ["/data"]

RUN /bin/rm /crate/config/*

ADD ["config/crate.yml", "/crate/config/crate.yml"]
ADD ["config/logging.yml", "/crate/config/logging.yml"]


WORKDIR /data

# http
EXPOSE 4200

# transport
EXPOSE 4300

#RUN yum -y install bash
CMD ["/crate/bin/crate"]
