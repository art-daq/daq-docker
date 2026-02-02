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

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer ]; then
  do_build=1
else
  # Check if the existing build is for the correct OS version
  if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer/spack/etc/spack/linux/almalinux${osVer} ]; then
    do_build=1
  else
    echo "Build area exists, checking artdaq-$artdaqVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer
    source setup-env.sh
    spack env activate artdaq-$artdaqVer
    spack install &>/dev/null || do_build=1
  fi
fi

if [ $do_build -eq 1 ];then
    echo "Building artdaq-$artdaqVer using Spack $spackVer on Alma$osVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
    mkdir artdaq-$artdaqVer;cd artdaq-$artdaqVer
    touch .cvmfscatalog
    rm quick-spack-start_${spackVer}.sh*
    wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start_${spackVer}.sh && chmod +x quick-spack-start_${spackVer}.sh
    ./quick-spack-start_${spackVer}.sh --tag $artdaqVer --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer
    cleanup
else
    echo "artdaq-$artdaqVer is up to date, no build needed"
fi

git config --global --unset-all safe.directory
