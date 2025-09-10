docker pull eflumerf/mu2e-spack:latest
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/mu2e-spack:latest /bin/bash
