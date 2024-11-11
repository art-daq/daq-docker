echo "Starting update/build of CVMFS spack_areas"

mkdir -p spack_areas

rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ spack_areas/

docker run -it -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs.sh

#rsync -ax --progress spack_areas/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_areas/

#ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh

echo "DONE"
