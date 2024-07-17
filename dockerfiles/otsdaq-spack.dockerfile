# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/artdaq-spack:latest

MAINTAINER Eric Flumerfelt "eflumerf@fnal.gov"
ENV REFRESHED_AT 2023-08-11

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/ots-quick-spack-start.sh /opt/artdaq/ots-quick-spack-start.sh

RUN chmod +x /opt/artdaq/ots-quick-spack-start.sh && ./ots-quick-spack-start.sh --develop --no-kmod
 
ENTRYPOINT ["/bin/bash", "-l", "-c" ]
