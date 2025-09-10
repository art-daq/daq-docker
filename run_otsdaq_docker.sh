docker pull eflumerf/otsdaq-spack:latest
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/otsdaq-spack:latest /bin/bash
