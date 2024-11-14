# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest AS intermediate

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/ots-quick-spack-start.sh /opt/otsdaq/ots-quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
COPY spack_areas/ /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/

RUN chmod +x /opt/otsdaq/ots-quick-spack-start.sh && ./ots-quick-spack-start.sh --develop --no-kmod --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq-v3_14_01 --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-s132 --arch linux-almalinux9-x86_64_v3
 
RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/otsdaq /opt/otsdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
