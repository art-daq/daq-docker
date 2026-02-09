#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
artdaqVer=${artdaqVer:-v4_05_00}
osVer=${osVer:-9}
spackVer=${spackVer:-v0.28}
force=${force:-0}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

# Check dependency
if ! [ -f /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-${artVer}-al${osVer}/.build_verified ]; then
    echo "Dependency art-suite-${artVer}-al${osVer} not built; please run update_cvmfs_art.sh first."
    git config --global --unset-all safe.directory
    exit 1
fi

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer-al${osVer} ]; then
  do_build=1
else
    echo "Build area exists, checking spack_${spackVer}/artdaq-$artdaqVer-al${osVer}"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer-al${osVer}

    if [ -f .build_verified ];then
        echo "Build previously verified, skipping Spack find test"
        do_build=0
    else
        echo "Setting up Spack"
        source setup-env.sh
        echo "activate artdaq-$artdaqVer-al${osVer}"
        spack env activate artdaq-$artdaqVer-al${osVer}
        echo "test install"
        spack find --format '{name}' artdaq-suite &>/dev/null || do_build=1
    fi
fi

if [ $do_build -eq 1 ];then
    echo "Building artdaq-$artdaqVer using Spack $spackVer on Alma$osVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
    mkdir artdaq-$artdaqVer-al${osVer};cd artdaq-$artdaqVer-al${osVer}
    touch .cvmfscatalog
    rm quick-spack-start_${spackVer}.sh*
    wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start_${spackVer}.sh && chmod +x quick-spack-start_${spackVer}.sh
    ./quick-spack-start_${spackVer}.sh --tag $artdaqVer --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer-al${osVer}
    cleanup
else
    echo "artdaq-$artdaqVer-al${osVer} is up to date, no build needed"
  touch .build_verified
fi

git config --global --unset-all safe.directory
