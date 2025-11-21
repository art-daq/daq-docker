# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/alma9-spack:latest AS intermediate

SHELL ["/bin/bash", "-c"]

ARG ARTDAQ_AREA=artdaq-v4_00_00
ARG ART_AREA=art-suite-s132

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/quick-spack-start.sh /opt/artdaq/quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA
COPY spack_areas/$ART_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA
COPY spack_areas/$ARTDAQ_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA

RUN chmod +x /opt/artdaq/quick-spack-start.sh && \
    ./quick-spack-start.sh --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA

RUN source setup-env.sh && spack clean -a

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM eflumerf/alma9-spack:latest

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
