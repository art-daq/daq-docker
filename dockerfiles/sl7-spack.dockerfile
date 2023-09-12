# This Dockerfile is used to build an headles vnc image based on Centos

FROM scientificlinux/sl:7

ENV REFRESHED_AT 2022-04-04

RUN yum install -y git python3 gcc-c++ gcc-gfortran make patch wget bzip2 unzip kernel-devel binutils-devel

RUN mkdir -p /opt && chmod go+rw /opt

WORKDIR /opt

RUN git clone https://github.com/FNALssi/spack.git -b fnal-develop

ADD https://raw.githubusercontent.com/art-daq/daq-docker/main/spack-utils/packages.yaml.sl7 /root/.spack/packages.yaml

WORKDIR /opt/spack/var/spack/repos

RUN git clone https://github.com/FNALssi/fnal_art.git

RUN source /opt/spack/share/spack/setup-env.sh \
    && spack compiler find \
    && spack repo add /opt/spack/var/spack/repos/fnal_art

RUN source /opt/spack/share/spack/setup-env.sh \
    && spack install --fail-fast gcc@11.3.0 \
    && spack load gcc@11.3.0 \
    && spack compiler find 

RUN source /opt/spack/share/spack/setup-env.sh \
    && spack load gcc@11.3.0 \
    && spack install --fail-fast binutils

# Build the stuff that doesn't need binutils...
RUN source /opt/spack/share/spack/setup-env.sh \
    && spack load gcc@11.3.0 \
    && spack install artdaq-suite@v3_12_05 ~pcp+demo s=124 %gcc@11.3.0 || true

# ...and then the stuff that does
RUN source /opt/spack/share/spack/setup-env.sh \
    && spack load gcc@11.3.0 \
    && spack load --first binutils%gcc@11.3.0
    && spack install --fail-fast artdaq-suite@v3_12_05 ~pcp+demo s=124 %gcc@11.3.0

ENTRYPOINT ["/bin/bash"]
