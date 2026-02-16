#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
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
    if ! [ -d ${base_dir}/art-suite-$artVer-al$osVer ]; then
        echo "Build area does not exist, cannot verify build"
        return 1
    fi

    res=0
    cd ${base_dir}/art-suite-$artVer-al$osVer
    if ! [ -f .build_verified ]; then
        echo "Verifying build, setting up Spack"
        source setup-env.sh
        echo "activate art-$artVer-al${osVer}"
        spack env activate art-$artVer-al${osVer}
        echo "test install"
        spack find --format '{name}' art-suite &>/dev/null || res=1
        spack env deactivate
        if [ $res -eq 0 ]; then
            touch .build_verified
        fi
    else
        echo "Build already verified, skipping verification step"
    fi

    return $res
}

if [ $force -eq 0 ]; then
    verify
    do_build=$?
else
    do_build=1
fi

if [ $do_build -eq 1 ];then
  echo "Building art-suite-$artVer using Spack $spackVer on Alma$osVer"
  cd ${base_dir}
  mkdir art-suite-$artVer-al$osVer
  cd art-suite-$artVer-al$osVer
  touch .cvmfscatalog
  rm .build_verified
  rm art-suite-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/art-suite-spack-start_${spackVer}.sh && chmod +x art-suite-spack-start_${spackVer}.sh
  ./art-suite-spack-start_${spackVer}.sh --padding --no-view -s ${artVer:1} --arch linux-almalinux${osVer}-x86_64_v3
  cleanup
  verify
else
  echo "art-suite-$artVer-al${osVer} is up to date, no build needed"
fi

git config --global --unset-all safe.directory
