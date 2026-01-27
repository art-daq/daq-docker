# This Dockerfile is used to create an otsdaq build area for Github Actions CI

SHELL ["/bin/bash", "-c"]

ARG OTS_AREA=ots-v3_00_00
ARG ARTDAQ_AREA=artdaq-v4_00_00
ARG ART_AREA=art-suite-s132
ARG BASE_IMAGE=eflumerf/alma9-spack:latest

FROM $BASE_IMAGE AS intermediate

WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/ots-quick-spack-start.sh /opt/otsdaq/ots-quick-spack-start.sh

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA
COPY spack_areas/$ART_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA
COPY spack_areas/$ARTDAQ_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$OTS_AREA
COPY spack_areas/$OTS_AREA /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$OTS_AREA

RUN chmod +x /opt/otsdaq/ots-quick-spack-start.sh && \
    ./ots-quick-spack-start.sh --develop --dev-only --no-kmod --arch linux-almalinux9-x86_64_v3 \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$OTS_AREA \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ARTDAQ_AREA \
                               --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/$ART_AREA

# Create setup_ots_rte.sh
RUN rm setup_ots_rte.sh && source setup_ots.sh && spack clean -a

RUN rm -rf /cvmfs/fermilab.opensciencegrid.org/products

FROM $BASE_IMAGE

COPY --from=intermediate /opt/otsdaq /opt/otsdaq

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
