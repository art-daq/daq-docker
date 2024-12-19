
#docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_art.sh
#docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_artdaq.sh
#docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_ots.sh
docker run -it --rm -v ./build_scripts:/opt/build_scripts -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_mu2e.sh

rsync -ax --delete --progress spack_areas/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_areas/

ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh

echo "DONE"
