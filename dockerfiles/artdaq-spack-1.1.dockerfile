# This Dockerfile is used to create an artdaq build area for Github Actions CI

SHELL ["/bin/bash", "-c"]

ARG ARTDAQ_AREA=artdaq-v4_05_00
ARG ART_AREA=art-suite-s132.1
ARG BASE_IMAGE=eflumerf/alma9-spack:latest

FROM $BASE_IMAGE AS intermediate

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/quick-spack-start_v1.sh /opt/artdaq/quick-spack-start_v1.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ART_AREA
COPY spack_v1.1/$ART_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ART_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ARTDAQ_AREA
COPY spack_v1.1/$ARTDAQ_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ARTDAQ_AREA

RUN chmod +x /opt/artdaq/quick-spack-start_v1.sh && \
    ./quick-spack-start_v1.sh --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ARTDAQ_AREA \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/$ART_AREA

# Create artdaq_demo_rte.sh
RUN source setupARTDAQDEMO && spack clean -a

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM $BASE_IMAGE

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
