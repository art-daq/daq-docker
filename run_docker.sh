#!/bin/bash

image=${image:-${1:-eflumerf/alma9-spack:latest}}

docker pull $image
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas $image
