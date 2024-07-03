# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest

MAINTAINER Eric Flumerfelt "eflumerf@fnal.gov"
ENV REFRESHED_AT 2023-08-11

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/ots-quick-spack-start.sh /opt/otsdaq/ots-quick-spack-start.sh

RUN chmod +x /opt/otsdaq/ots-quick-spack-start.sh && ./ots-quick-spack-start.sh --develop
 
ENTRYPOINT ["/bin/bash", "-l", "-c" ]