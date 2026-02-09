#!/bin/bash

os=$(cat /etc/redhat-release|grep -oE "release [0-9]+"|cut -d' ' -f2)
image=${image:-${1:-eflumerf/alma${os}-spack:latest}}

docker pull $image
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/ $image
