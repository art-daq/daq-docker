#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s132.1}
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

if [ $force -eq 1 ] || ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer/spack/etc/spack/linux/almalinux${osVer} ];then
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
