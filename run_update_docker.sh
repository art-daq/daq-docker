#!/bin/bash

artVer=s134
artdaqVer=v4_10_00
otsVer=v3_10_00
mu2eVer=v13_00_00

doArtBuild=1
doArtdaqBuild=1
doOtsBuild=1
doMu2eBuild=1
update_local=1
update_cvmfs=0

checkOnly=0
forceArtBuild=0
forceArtdaqBuild=0
forceOtsBuild=0
forceMu2eBuild=0

al9Build=$(cat /etc/redhat-release|grep -c "release 9")
al10Build=$(cat /etc/redhat-release|grep -c "release 10")

if [ ${al9Build:-0} -eq 1 ];then
  osVer=9
elif [ ${al10Build:-0} -eq 1 ];then
  osVer=10
fi

spack0Build=1
spack1Build=1

if [ $update_local -eq 1 ];then
    # art
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v0.28/art-suite-$artVer-al$osVer spack_v0.28/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/art-suite-$artVer-al$osVer spack_v1.1/
    # artdaq
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v0.28/artdaq-$artdaqVer-al$osVer spack_v0.28/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/artdaq-$artdaqVer-al$osVer spack_v1.1/
    # ots
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v0.28/ots-$otsVer-al$osVer spack_v0.28/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/ots-$otsVer-al$osVer spack_v1.1/
    # mu2e
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v0.28/mu2e-tdaq-$mu2eVer-al$osVer spack_v0.28/
    rsync -ax --progress /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_v1.1/mu2e-tdaq-$mu2eVer-al$osVer spack_v1.1/
fi

function build_areas() {
    spackVer=$1
    image="eflumerf/alma${osVer}-spack:latest"

    docker pull $image

    if [ $doArtBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e force=$forceArtBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
		   -e checkOnly=$checkOnly \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/build_art.sh
    fi

    if [ $doArtdaqBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e artdaqVer=$artdaqVer \
                   -e force=$forceArtdaqBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
		   -e checkOnly=$checkOnly \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/build_artdaq.sh
    fi

    if [ $doOtsBuild -eq 1 ];then
        docker run -it --rm \
                   -e artVer=$artVer \
                   -e artdaqVer=$artdaqVer \
                   -e otsVer=$otsVer \
                   -e force=$forceOtsBuild \
                   -e osVer=$osVer \
                   -e spackVer=$spackVer \
		   -e checkOnly=$checkOnly \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/build_ots.sh
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
		   -e checkOnly=$checkOnly \
                   -v ./build_scripts:/opt/build_scripts \
                   -v ./spack_$spackVer:/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_$spackVer \
                   $image /opt/build_scripts/build_mu2e.sh
    fi
}

if [ $spack0Build -eq 1 ];then
    build_areas "v0.28"
fi
if [ $spack1Build -eq 1 ];then
    build_areas "v1.1"
fi

if [ $update_cvmfs -eq 1 ];then
    rsync -ax --progress spack_v0.28/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_v0.28/
    rsync -ax --progress spack_v1.1/ artdaq@artdaqgpvm01:/grid/fermiapp/products/artdaq/spack_v1.1/
    ssh artdaq@artdaqgpvm01 ./update_cvmfs.sh
fi

echo "DONE"
