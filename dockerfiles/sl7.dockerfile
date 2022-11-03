# This Dockerfile is used to build an headles vnc image based on Centos

FROM eflumerf/sl7-minimal:latest

MAINTAINER Eric Flumerfelt "eflumerf@fnal.gov"
ENV REFRESHED_AT 2022-11-01

SHELL ["/bin/bash", "-c"]
WORKDIR /opt/otsdaq

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/quick-mrb-start.sh /opt/otsdaq/quick-mrb-start.sh

RUN chmod +x /opt/otsdaq/quick-mrb-start.sh && ./quick-mrb-start.sh && rm -f /opt/otsdaq/products/*.bz2
 
WORKDIR /opt/otsdaq

RUN source setup_ots.sh && cd srcs && for pkg in \
 trace artdaq_core artdaq_utilities artdaq_mfextensions artdaq_epics_plugin \
 artdaq_pcp_mmv_plugin artdaq artdaq_core_demo artdaq_demo artdaq_daqinterface \
 artdaq_demo_hdf5 artdaq_database otsdaq otsdaq_utilities otsdaq_components \
 otsdaq_epics otsdaq_prepmodernization;do \
 git clone https://github.com/art-daq/$pkg -b develop ;done && mv trace TRACE && \
 for dir in */;do cd $dir;git checkout develop;cd ..;done && \
 mrb uc

ADD https://raw.githubusercontent.com/art-daq/otsdaq_demo/develop/tools/fetch_products.sh /opt/otsdaq/products/fetch_products.sh

WORKDIR /opt/otsdaq/products

RUN chmod +x /opt/otsdaq/products/fetch_products.sh && ./fetch_products.sh

WORKDIR /opt/otsdaq

RUN source setup_ots.sh && mrb z && mrbsetenv && mrb uc && mrb b

ENTRYPOINT ["/bin/bash", "-l", "-c" ]
