# This Dockerfile is used to create an otsdaq build area for Github Actions CI

ARG BASE_IMAGE=eflumerf/alma9-spack:latest

FROM $BASE_IMAGE AS intermediate

ARG OTS_AREA=ots-v3_05_00
ARG ARTDAQ_AREA=artdaq-v4_05_00
ARG ART_AREA=art-suite-s132.1
ARG SPACK_VERSION=v0.28
ARG SCRIPT_NAME=ots-quick-spack-start_${SPACK_VERSION}.sh

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/$SCRIPT_NAME /opt/otsdaq/$SCRIPT_NAME

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ART_AREA
COPY spack_${SPACK_VERSION}/$ART_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ART_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ARTDAQ_AREA
COPY spack_${SPACK_VERSION}/$ARTDAQ_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ARTDAQ_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$OTS_AREA
COPY spack_${SPACK_VERSION}/$OTS_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$OTS_AREA

RUN chmod +x /opt/otsdaq/$SCRIPT_NAME && \
    ./$SCRIPT_NAME --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                   --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$OTS_AREA \
                   --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ARTDAQ_AREA \
                   --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/$ART_AREA

# Create setup_ots_rte.sh
RUN rm setup_ots_rte.sh && source setup_ots.sh && spack clean -a

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM $BASE_IMAGE

COPY --from=intermediate /opt/otsdaq /opt/otsdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
