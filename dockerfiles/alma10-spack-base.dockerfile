# This Dockerfile is used to build an headles vnc image based on Centos

FROM almalinux:10

ENV REFRESHED_AT 2025-12-19

# Tools for building the DAQ release

RUN dnf clean all \
 && dnf -y install epel-release dnf-plugins-core \
 && dnf -y upgrade \
 && dnf config-manager --set-enabled crb \
 && dnf clean all

# Tools for building the DAQ release
RUN dnf install -y kernel-devel asciidoc bzip2 bzip2-devel bzip2-libs \
                   cyrus-sasl-devel expat-devel elfutils elfutils-devel elfutils-libs fontconfig-devel \
                   freetype-devel gcc gcc-c++ gcc-gfortran gdb gdbm gdbm-devel gettext-devel git \
                   glibc-devel gperf gtk3-devel java-latest-openjdk java-latest-openjdk-devel \
                   java-latest-openjdk-headless krb5-devel libICE-devel libSM-devel libX11-devel \
                   libXdmcp-devel libXext-devel libXft-devel libXi-devel libXmu-devel libXpm-devel \
                   libXrandr-devel libXrender-devel libXt-devel libXv-devel libXxf86vm-devel \
                   libbsd-devel libcurl-devel libdb-devel libfontenc-devel libgcc libnsl2 librdmacm \
                   libtirpc-devel libtool libunwind-devel libuuid-devel libxkbcommon-devel \
                   libxkbcommon-x11-devel libxshmfence-devel make mesa-libGL-devel mesa-libGLU \
                   mesa-libGLU-devel ncurses-compat-libs ncurses-devel ninja-build numactl-devel \
                   openssh-server openssl openssl-devel patch patchelf perl-devel python3 \
                   python3-devel python3-libs python3-pip python3-pyyaml python3-setuptools \
                   python3-setuptools_scm readline-devel rsync tar tcl-devel texinfo tk tk-devel unzip \
                   wget xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel \
                   xcb-util-wm-devel xorg-x11-util-macros xorg-x11-xtrans-devel xxhash xxhash-libs \
                   xz-devel zip binutils-devel doxygen jq procps-ng zlib-ng-compat-static \
                   qt5 qt5-qtbase qt5-qtbase-gui qt5-qtbase-devel \
&& dnf clean all


ENTRYPOINT ["/bin/bash"]
