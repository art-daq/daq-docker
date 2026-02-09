#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
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

dir=/cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer-al${osVer}

do_build=${force}
if ! [ -d $dir ]; then
  do_build=1
else
    echo "Build area exists, checking spack_${spackVer}/art-suite-$artVer-al${osVer}"
    cd $dir

    if [ -f .build_verified ];then
        echo "Build previously verified, skipping Spack find test"
        do_build=0
    else
        echo "Setting up Spack"
        source setup-env.sh
        echo "activate art-$artVer-al${osVer}"
        spack env activate art-$artVer-al${osVer}
        echo "test install"
        spack find --format '{name}' art-suite &>/dev/null || do_build=1
        spack env deactivate
    fi
fi

if [ $do_build -eq 1 ];then
  echo "Building art-suite-$artVer using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir art-suite-$artVer-al$osVer;cd art-suite-$artVer-al$osVer
  touch .cvmfscatalog
  rm art-suite-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/art-suite-spack-start_${spackVer}.sh && chmod +x art-suite-spack-start_${spackVer}.sh
  ./art-suite-spack-start_${spackVer}.sh --padding --no-view -s ${artVer:1} --arch linux-almalinux${osVer}-x86_64_v3
  cleanup
else
  echo "art-suite-$artVer-al${osVer} is up to date, no build needed"
  touch .build_verified
fi

git config --global --unset-all safe.directory
