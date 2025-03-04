# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest AS intermediate

SHELL ["/bin/bash", "-c"]

ARG ARTDAQVER=v4_00_00
ARG ARTVER=s132

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/quick-spack-start.sh /opt/artdaq/quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER
COPY spack_areas/art-suite-$ARTVER /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER
COPY spack_areas/artdaq-$ARTDAQVER /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER

RUN chmod +x /opt/artdaq/quick-spack-start.sh && \
    ./quick-spack-start.sh --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER
 
RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
