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
al10Build=1

spack0Build=1
spack1Build=1

if [ $update_local -eq 1 ];then
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v0.28/ spack_v0.28/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/ spack_v1.1/
fi

function build_areas() {
    osVer=$1
    spackVer=$2
    image="eflumerf/alma${osVer}-spack:latest"

    docker pull $image

    if [ $doArtBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e force=$forceArtBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/update_cvmfs_art.sh
    fi

    if [ $doArtdaqBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e artdaqVer=$artdaqVer \
                   -e force=$forceArtdaqBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/update_cvmfs_artdaq.sh
    fi

    if [ $doOtsBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e artdaqVer=$artdaqVer \
                   -e otsVer=$otsVer \
                   -e force=$forceOtsBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/update_cvmfs_ots.sh
    fi

    if [ $doMu2eBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e artdaqVer=$artdaqVer \
                   -e otsVer=$otsVer \
                   -e mu2eVer=$mu2eVer \
                   -e force=$forceMu2eBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/update_cvmfs_mu2e.sh
    fi
}

if [ $al9Build -eq 1 ];then
    if [ $spack0Build -eq 1 ];then
        build_areas 9 "v0.28"
    fi
    if [ $spack1Build -eq 1 ];then
        build_areas 9 "v1.1"
    fi
fi
if [ $al10Build -eq 1 ];then
    if [ $spack0Build -eq 1 ];then
        build_areas 10 "v0.28"
    fi
    if [ $spack1Build -eq 1 ];then
        build_areas 10 "v1.1"
    fi
fi

if [ $update_cvmfs -eq 1 ];then
    delete_arg=""
    if [ $forceArtBuild -eq 1 ] || [ $forceArtdaqBuild -eq 1 ] || [ $forceOtsBuild -eq 1 ] || [ $forceMu2eBuild -eq 1 ]; then
        delete_arg="--delete"
    fi
    rsync -ax $delete_arg --progress spack_v0.28/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_v0.28/
    rsync -ax $delete_arg --progress spack_v1.1/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_v1.1/
    ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh
fi

echo "DONE"
