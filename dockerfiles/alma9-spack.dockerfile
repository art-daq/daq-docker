# This Dockerfile is used to build an headles vnc image based on Centos

FROM almalinux:9

ENV REFRESHED_AT 2023-02-27

# Tools for building the DAQ release

RUN yum clean all \
 && yum -y install epel-release dnf-plugins-core \
 && yum -y upgrade \
 && dnf config-manager --set-enabled crb \
 && yum clean all

# Tools for building the DAQ release
RUN dnf install -y asciidoc bzip2 bzip2-devel bzip2-libs compat-openssl11 cyrus-sasl-devel expat-devel fontconfig-devel freetype-devel gcc gcc-c++ gcc-gfortran gdb gdbm gdbm-devel gettext-devel git glibc-devel gperf gtk3-devel java-1.8.0-openjdk java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless krb5-devel libICE-devel libSM-devel libX11-devel libXdmcp-devel libXext-devel libXft-devel libXi-devel libXmu-devel libXpm-devel libXrandr-devel libXrender-devel libXt-devel libXv-devel libXxf86vm-devel libbsd-devel libcurl-devel libdb-devel libfontenc-devel libgcc libnsl2 librdmacm libtirpc-devel libtool libunwind-devel libuuid-devel libxkbcommon-devel libxkbcommon-x11-devel libxshmfence-devel make mesa-libGL-devel mesa-libGLU mesa-libGLU-devel ncurses-compat-libs ncurses-devel ninja-build numactl-devel openssh-server openssl openssl-devel patch patchelf perl-devel python3 python3-apipkg python3-devel python3-libs python3-pip python3-pyyaml python3-setuptools python3-setuptools_scm readline-devel rsync tar tcl-devel texinfo tk tk-devel unzip wget xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel xcb-util-wm-devel xorg-x11-util-macros xorg-x11-xtrans-devel xxhash xxhash-libs xz-devel zip binutils-devel \
&& dnf clean all


ENTRYPOINT ["/bin/bash"]
