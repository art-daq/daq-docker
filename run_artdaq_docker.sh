docker pull eflumerf/artdaq-spack:latest
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/artdaq-spack:latest /bin/bash
