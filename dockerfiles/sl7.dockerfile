# This Dockerfile is used to build an headles vnc image based on Centos

FROM scientificlinux/sl:7

MAINTAINER Pengfei Ding "dingpf@fnal.gov"
ENV REFRESHED_AT 2020-10-19

RUN yum clean all \
 && yum -y install epel-release \
 && yum -y install https://repo.ius.io/ius-release-el7.rpm \
 && yum -y update \
 && yum -y install yum-plugin-priorities \
 git236 subversion asciidoc bzip2-devel \
 fontconfig-devel freetype-devel gdbm-devel glibc-devel \
 ncurses-devel openssl-devel openldap-devel readline-devel \
 autoconf automake libtool swig texinfo tcl-devel tk-devel \
 xz-devel xmlto zlib-devel libcurl-devel libjpeg-turbo-devel \
 libpng-devel libstdc++-devel libuuid-devel libX11-devel \
 libXext-devel libXft-devel libXi-devel libXrender-devel \
 libXt-devel libXpm-devel libXmu-devel mesa-libGL-devel \
 mesa-libGLU-devel perl-DBD-SQLite perl-ExtUtils-MakeMaker \
 gcc gcc-c++ libgcc.i686 glibc-devel.i686 libstdc++.i686 libffi-devel \
 && yum -y install yum-plugin-priorities \
 nc perl expat-devel gdb time tar zip xz bzip2 patch sudo which strace \
 openssh-clients rsync tmux svn wget cmake \
 gcc gstreamer gtk2-devel xterm \
 gstreamer-plugins-base-devel lynx  \
 vim which net-tools xorg-x11-fonts* \
 xorg-x11-server-utils xorg-x11-twm dbus dbus-x11 \
 libuuid-devel wget redhat-lsb-core openssh-server \
 && yum clean all

RUN yum clean all \
 && yum --enablerepo=epel -y install htop osg-wn-client \
 libconfuse-devel xvfb nss_wrapper gettext libzstd libzstd-devel openssl \
 && yum clean all

RUN yum clean all \
 && yum -y install java-11-openjdk \
 && yum clean all


ENV UPS_OVERRIDE="-H Linux64bit+3.10-2.17"

RUN dbus-uuidgen > /var/lib/dbus/machine-id

RUN yum clean all \
 && yum -y install glew-devel unzip perl-ExtUtils-Embed expect \
 && yum clean all

RUN yum clean all \
 && yum -y install xxhash cyrus-sasl-devel xxhash-libs \
 && yum clean all
 

SHELL ["/bin/bash", "-c"]
WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/quick-mrb-start.sh /opt/otsdaq/quick-mrb-start.sh

RUN chmod +x /opt/otsdaq/quick-mrb-start.sh && ./quick-mrb-start.sh && rm -f /opt/otsdaq/products/*.bz2
 
WORKDIR /opt/otsdaq

RUN source setup_ots.sh && cd srcs && for pkg in \
 trace artdaq_core artdaq_utilities artdaq_mfextensions artdaq_epics_plugin \
 artdaq_pcp_mmv_plugin artdaq artdaq_core_demo artdaq_demo artdaq_daqinterface \
 artdaq_demo_hdf5 artdaq_database otsdaq otsdaq_utilities otsdaq_components \
 otsdaq_epics otsdaq_prepmodernization otsdaq_demo;do \
 mrb gitCheckout https://github.com/art-daq/$pkg ;done && mv trace TRACE && \
 for dir in */;do cd $dir;git checkout develop;cd ..;done

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/fetch_products.sh /opt/otsdaq/products/fetch_products.sh

WORKDIR /opt/otsdaq/products

RUN chmod +x /opt/otsdaq/products/fetch_products.sh && ./fetch_products.sh

WORKDIR /opt/otsdaq

RUN source setup_ots.sh && mrb z && mrbsetenv && mrb b

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
