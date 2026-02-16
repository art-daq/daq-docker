# This Dockerfile is used to create an artdaq build area for Github Actions CI

ARG BASE_IMAGE=eflumerf/alma9-spack:latest

FROM ${BASE_IMAGE} AS intermediate

ARG ARTDAQ_AREA=artdaq-v4_05_00-al9
ARG ART_AREA=art-suite-s133-al9
ARG SPACK_VERSION=v0.28
ARG SCRIPT_NAME=quick-spack-start_${SPACK_VERSION}.sh

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/artdaq

ADD https://raw.githubusercontent.com/art-daq/artdaq_demo/develop/tools/${SCRIPT_NAME} /opt/artdaq/${SCRIPT_NAME}

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ART_AREA}
COPY spack_${SPACK_VERSION}/${ART_AREA} /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ART_AREA}

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ARTDAQ_AREA}
COPY spack_${SPACK_VERSION}/${ARTDAQ_AREA} /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ARTDAQ_AREA}

RUN chmod +x /opt/artdaq/${SCRIPT_NAME} && \
    ./${SCRIPT_NAME} --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                   --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ARTDAQ_AREA} \
                   --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${SPACK_VERSION}/${ART_AREA}

# Create artdaq_demo_rte.sh
RUN rm artdaq_demo_rte.sh && source setupARTDAQDEMO && spack clean -a

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM $BASE_IMAGE

COPY --from=intermediate /opt/artdaq /opt/artdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
