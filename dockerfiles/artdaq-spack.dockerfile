# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest AS intermediate

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/quick-spack-start.sh /opt/artdaq/quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
COPY spack_areas/ /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/

RUN chmod +x /opt/artdaq/quick-spack-start.sh && ./quick-spack-start.sh --develop --no-kmod --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-v3_14_01 --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-s132 --arch linux-almalinux9-x86_64_v3
 
RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
