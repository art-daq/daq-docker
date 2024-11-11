docker run -it -v ./build_scripts:/opt/build_scripts -v ./artdaq_spack:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack eflumerf/otsdaq-spack:latest /opt/build_scripts/update_cvmfs.sh

rsync -ax --progress artdaq_spack/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/artdaq_spack/
