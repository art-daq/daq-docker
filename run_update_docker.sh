#!/bin/bash

artVer=s132
artdaqVer=v3_16_00
otsVer=v2_10_00
mu2eVer=v3_04_00

doArtBuild=1
doArtdaqBuild=1
doOtsBuild=1
doMu2eBuild=1

forceArtBuild=0
forceArtdaqBuild=0
forceOtsBuild=0
forceMu2eBuild=0

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
           -v ./build_scripts:/opt/build_scripts \
           -v ./spack_areas:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas \
           eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_mu2e.sh
fi

rsync -ax --delete --progress spack_areas/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_areas/

ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh

echo "DONE"
