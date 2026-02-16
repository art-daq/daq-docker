#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
artdaqVer=${artdaqVer:-v4_05_00}
otsVer=${otsVer:-v3_05_00}
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
    if ! [ -d ${base_dir}/ots-$otsVer-al${osVer} ]; then
        echo "Build area does not exist, cannot verify build"
        return 1
    fi

    res=0
    cd ${base_dir}/ots-$otsVer-al${osVer}
    if ! [ -f .build_verified ]; then
        echo "Verifying build, setting up Spack"
        source setup-env.sh
        echo "activate ots-$otsVer-al${osVer}"
        spack env activate ots-$otsVer-al${osVer}
        echo "test install"
        spack find --format '{name}' otsdaq-suite &>/dev/null || res=1
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
if ! [ -f ${base_dir}/artdaq-${artdaqVer}-al${osVer}/.build_verified ]; then
    echo "Dependency artdaq-${artdaqVer}-al${osVer} not built; please run update_cvmfs_artdaq.sh first."
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
  echo "Building ots-$otsVer-al${osVer} using Spack $spackVer on Alma$osVer"
  cd ${base_dir}
  mkdir ots-$otsVer-al${osVer}
  cd ots-$otsVer-al${osVer}
  touch .cvmfscatalog
  rm .build_verified
  rm ots-quick-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start_${spackVer}.sh && chmod +x ots-quick-spack-start_${spackVer}.sh
  ./ots-quick-spack-start_${spackVer}.sh --padding --no-kmod --no-view --arch linux-almalinux${osVer}-x86_64_v3 --tag $otsVer \
                             --upstream ${base_dir}/artdaq-$artdaqVer-al${osVer} \
                             --upstream ${base_dir}/art-suite-$artVer-al${osVer}
  cleanup
  verify
else
  echo "ots-$otsVer-al${osVer} is up to date, no build needed"
fi

git config --global --unset-all safe.directory
