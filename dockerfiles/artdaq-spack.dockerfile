# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest as intermediate

MAINTAINER Eric Flumerfelt "eflumerf@fnal.gov"
ENV REFRESHED_AT 2023-08-11

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/quick-spack-start.sh /opt/artdaq/quick-spack-start.sh

ADD /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack

RUN chmod +x /opt/artdaq/quick-spack-start.sh && ./quick-spack-start.sh --develop --no-kmod --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack
 
RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
