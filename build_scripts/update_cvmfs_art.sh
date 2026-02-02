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

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer ]; then
  do_build=1
else
  # Check if the existing build is for the correct OS version
  if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer/spack/etc/spack/linux/almalinux${osVer} ]; then
    do_build=1
  else
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer
    source setup-env.sh
    spack env activate art-$artVer
    spack install || do_build=1
  fi
fi

if [ $do_build -eq 1 ];then
  echo "Building art-suite-$artVer using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir art-suite-$artVer;cd art-suite-$artVer
  touch .cvmfscatalog
  rm art-suite-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/art-suite-spack-start_${spackVer}.sh && chmod +x art-suite-spack-start_${spackVer}.sh
  ./art-suite-spack-start_${spackVer}.sh --padding --no-view -s ${artVer:1} --arch linux-almalinux${osVer}-x86_64_v3
  cleanup
fi

git config --global --unset-all safe.directory
