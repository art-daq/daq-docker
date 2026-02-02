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

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer ]; then
  do_build=1
else
  # Check if the existing build is for the correct OS version
  if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer/spack/etc/spack/linux/almalinux${osVer} ]; then
    do_build=1
  else
    echo "Build area exists, checking spack_${spackVer}/ots-$otsVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer
    source setup-env.sh
    spack env activate ots-$otsVer
    spack install &>/dev/null || do_build=1
  fi
fi

if [ $do_build -eq 1 ];then
  echo "Building ots-$otsVer using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir ots-$otsVer;cd ots-$otsVer
  touch .cvmfscatalog
  rm ots-quick-spack-start_${spackVer}.sh
  wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start_${spackVer}.sh && chmod +x ots-quick-spack-start_${spackVer}.sh
  ./ots-quick-spack-start_${spackVer}.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $otsVer \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer
  cleanup
else
  echo "ots-$otsVer is up to date, no build needed"
fi

git config --global --unset-all safe.directory
