# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest AS intermediate

SHELL ["/bin/bash", "-c"]

ARG OTSVER=v3_00_00
ARG ARTDAQVER=v4_00_00
ARG ARTVER=s132

WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/ots-quick-spack-start.sh /opt/otsdaq/ots-quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER
COPY spack_areas/art-suite-$ARTVER /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER
COPY spack_areas/artdaq-$ARTDAQVER /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$OTSVER
COPY spack_areas/ots-$OTSVER /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$OTSVER

RUN chmod +x /opt/otsdaq/ots-quick-spack-start.sh && \
    ./ots-quick-spack-start.sh --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$OTSVER \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$ARTDAQVER \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$ARTVER

RUN source setup-env.sh && spack env activate ots-develop

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/otsdaq /opt/otsdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
