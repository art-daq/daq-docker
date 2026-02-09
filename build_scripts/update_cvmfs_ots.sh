#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
artdaqVer=${artdaqVer:-v4_05_00}
otsVer=${otsVer:-v3_05_00}
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
if ! [ -f /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-${artdaqVer}-al${osVer}/.build_verified ]; then
    echo "Dependency artdaq-${artdaqVer}-al${osVer} not built; please run update_cvmfs_artdaq.sh first."
    git config --global --unset-all safe.directory
    exit 1
fi

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer-al${osVer} ]; then
  do_build=1
else
    echo "Build area exists, checking spack_${spackVer}/ots-$otsVer-al${osVer}"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer-al${osVer}

    if [ -f .build_verified ];then
        echo "Build previously verified, skipping Spack find test"
        do_build=0
    else
        echo "Setting up Spack"
        source setup-env.sh
        echo "activate ots-$otsVer-al${osVer}"
        spack env activate ots-$otsVer-al${osVer}
        echo "test install"
        spack find --format '{name}' otsdaq-suite &>/dev/null || do_build=1
    fi
fi

if [ $do_build -eq 1 ];then
  echo "Building ots-$otsVer-al${osVer} using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir ots-$otsVer-al${osVer};cd ots-$otsVer-al${osVer}
  touch .cvmfscatalog
  rm ots-quick-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start_${spackVer}.sh && chmod +x ots-quick-spack-start_${spackVer}.sh
  ./ots-quick-spack-start_${spackVer}.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $otsVer \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer-al${osVer} \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer-al${osVer}
  cleanup
else
  echo "ots-$otsVer-al${osVer} is up to date, no build needed"
  touch .build_verified
fi

git config --global --unset-all safe.directory
