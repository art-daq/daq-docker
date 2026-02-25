#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
artdaqVer=${artdaqVer:-v4_05_00}
osVer=${osVer:-9}
spackVer=${spackVer:-v0.28}
force=${force:-0}
base_dir=${base_dir:-/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

function verify() {
    if ! [ -d ${base_dir}/artdaq-$artdaqVer-al${osVer} ]; then
        echo "Build area does not exist, cannot verify build"
        return 1
    fi

    res=0
    cd ${base_dir}/artdaq-$artdaqVer-al${osVer}
    if ! [ -f .build_verified ]; then
        echo "Verifying build, setting up Spack"
        source setup-env.sh
        echo "activate artdaq-$artdaqVer-al${osVer}"
        spack env activate artdaq-$artdaqVer-al${osVer}
        echo "test install"
        spack find --format '{name}' artdaq-suite &>/dev/null || res=1
        spack env deactivate
        if [ $res -eq 0 ]; then
            touch .build_verified
        fi
    else
        echo "Build already verified, skipping verification step"
    fi

    return $res
}

# Check dependency
if ! [ -f ${base_dir}/art-suite-${artVer}-al${osVer}/.build_verified ]; then
    echo "Dependency art-suite-${artVer}-al${osVer} not built; please run update_cvmfs_art.sh first."
    git config --global --unset-all safe.directory
    exit 1
fi

if [ $force -eq 0 ]; then
    verify
    do_build=$?
else
    do_build=1
fi

if [ $do_build -eq 1 ];then
    echo "Building artdaq-$artdaqVer using Spack $spackVer on Alma$osVer"
    cd ${base_dir}
    mkdir artdaq-$artdaqVer-al${osVer}
    cd artdaq-$artdaqVer-al${osVer}
    touch .cvmfscatalog
    rm .build_verified
    rm quick-spack-start_${spackVer}.sh*
    wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start_${spackVer}.sh && chmod +x quick-spack-start_${spackVer}.sh
    ./quick-spack-start_${spackVer}.sh --tag $artdaqVer --padding --no-kmod --caen --no-view --arch linux-almalinux${osVer}-x86_64_v3 \
                           --upstream ${base_dir}/art-suite-$artVer-al${osVer}
    cleanup
    verify
else
    echo "artdaq-$artdaqVer-al${osVer} is up to date, no build needed"
fi

git config --global --unset-all safe.directory
