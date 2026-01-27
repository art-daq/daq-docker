#!/bin/bash

artVer=s132.1
artdaqVer=v4_05_00
otsVer=v3_05_00
mu2eVer=v10_00_00

doArtBuild=1
doArtdaqBuild=1
doOtsBuild=1
doMu2eBuild=0
update_local=0
update_cvmfs=0

forceArtBuild=0
forceArtdaqBuild=0
forceOtsBuild=0
forceMu2eBuild=0

al9Build=1

spack0Build=1
spack1Build=1

if [ $update_local -eq 1 ];then
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ spack_areas/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/ spack_v1.1/
fi

docker pull eflumerf/alma9-spack:latest

if [ ${spack0Build:-0} -eq 1];then
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
fi

if [ ${spack1Build:-0} -eq 1];then
    if [ $doArtBuild -eq 1 ];then
    docker run -it --rm \
               -e artVer=$artVer \
               -e force=$forceArtBuild \
               -v ./build_scripts:/opt/build_scripts \
               -v ./spack_v1.1:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1 \
               eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_art_v1.sh
    fi

    if [ $doArtdaqBuild -eq 1 ];then
    docker run -it --rm \
               -e artVer=$artVer \
               -e artdaqVer=$artdaqVer \
               -e force=$forceArtdaqBuild \
               -v ./build_scripts:/opt/build_scripts \
               -v ./spack_v1.1:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1 \
               eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_artdaq_v1.sh
    fi

    if [ $doOtsBuild -eq 1 ];then
    docker run -it --rm \
               -e artVer=$artVer \
               -e artdaqVer=$artdaqVer \
               -e otsVer=$otsVer \
               -e force=$forceOtsBuild \
               -v ./build_scripts:/opt/build_scripts \
               -v ./spack_v1.1:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1 \
               eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_ots_v1.sh
    fi

    if [ $doMu2eBuild -eq 1 ];then
    docker run -it --rm \
               -e artVer=$artVer \
               -e artdaqVer=$artdaqVer \
               -e otsVer=$otsVer \
               -e mu2eVer=$mu2eVer \
               -e force=$forceMu2eBuild \
               -v ./build_scripts:/opt/build_scripts \
               -v ./spack_v1.1:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1 \
               eflumerf/alma9-spack:latest /opt/build_scripts/update_cvmfs_mu2e_v1.sh
    fi
fi
if [ $update_cvmfs -eq 1 ];then
    delete_arg=""
    if [ $forceArtBuild -eq 1 ] || [ $forceArtdaqBuild -eq 1 ] || [ $forceOtsBuild -eq 1 ] || [ $forceMu2eBuild -eq 1 ]; then
        delete_arg="--delete"
    fi
    rsync -ax $delete_arg --progress spack_areas/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_areas/
    rsync -ax $delete_arg --progress spack_v1.1/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_v1.1/
    ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh
fi

echo "DONE"
