#!/bin/bash

artVer=s132
artdaqVer=v4_03_01
otsVer=v3_03_01
mu2eVer=v8_00_00_cand

doArtBuild=1
doArtdaqBuild=1
doOtsBuild=1
doMu2eBuild=1
update_local=1
update_cvmfs=1

forceArtBuild=0
forceArtdaqBuild=0
forceOtsBuild=0
forceMu2eBuild=0

developArtdaqBuild=0
developOtsBuild=0
developMu2eBuild=0

docker pull eflumerf/alma9-spack:latest
if [ $updateLocal -eq 1 ];then
  rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ spack_areas/
fi

if [ $doArtBuild -eq 1 ];then
docker run -it --rm \
           -e artVer=$artVer \
           -e force=$forceArtBuild \
           -v ./build_scripts:/opt/build_scripts \
           -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas \
           eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_art.sh
fi

if [ $doArtdaqBuild -eq 1 ];then
docker run -it --rm \
           -e artVer=$artVer \
           -e artdaqVer=$artdaqVer \
           -e force=$forceArtdaqBuild \
	   -e develop=$developArtdaqBuild \
           -v ./build_scripts:/opt/build_scripts \
           -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas \
           eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_artdaq.sh
fi

if [ $doOtsBuild -eq 1 ];then
docker run -it --rm \
           -e artVer=$artVer \
           -e artdaqVer=$artdaqVer \
           -e otsVer=$otsVer \
           -e force=$forceOtsBuild \
	   -e develop=$developOtsBuild \
           -v ./build_scripts:/opt/build_scripts \
           -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas \
           eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_ots.sh
fi

if [ $doMu2eBuild -eq 1 ];then
docker run -it --rm \
           -e artVer=$artVer \
           -e artdaqVer=$artdaqVer \
           -e otsVer=$otsVer \
           -e mu2eVer=$mu2eVer \
           -e force=$forceMu2eBuild \
	   -e develop=$developMu2eBuild \
           -v ./build_scripts:/opt/build_scripts \
           -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas \
           eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_mu2e.sh
fi

if [ $update_cvmfs -eq 1 ];then
    delete_arg=""
    if [ $forceArtBuild -eq 1 ] || [ $forceArtdaqBuild -eq 1 ] || [ $forceOtsBuild -eq 1 ] || [ $forceMu2eBuild -eq 1 ]; then
        delete_arg="--delete"
    fi
    rsync -ax $delete_arg --progress spack_areas/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_areas/
    ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh
fi

echo "DONE"
