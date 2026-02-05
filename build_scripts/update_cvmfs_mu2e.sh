#!/bin/bash

git config --global --add safe.directory '*'

artVer=${artVer:-s133}
artdaqVer=${artdaqVer:-v4_05_00}
otsVer=${otsVer:-v3_05_00}
mu2eVer=${mu2eVer:-v10_00_00}
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
if ! [ -f /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer/.build_verified ]; then
    echo "Dependency ots-$otsVer not built; please run update_cvmfs_ots.sh first."
    git config --global --unset-all safe.directory
    exit 1
fi

do_build=${force}
if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/mu2e-tdaq-$mu2eVer ]; then
  do_build=1
else
  # Check if the existing build is for the correct OS version
  if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/mu2e-tdaq-$mu2eVer/spack/etc/spack/linux/almalinux${osVer} ]; then
    do_build=1
  else
    echo "Build area exists, checking spack_${spackVer}/mu2e-tdaq-$mu2eVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/mu2e-tdaq-$mu2eVer
    
    if [ -f .build_verified ];then
        echo "Build previously verified, skipping Spack find test"
        do_build=0
    else
        echo "Setting up Spack"
        source setup-env.sh
        echo "activate tdaq-$mu2eVer"
        spack env activate tdaq-$mu2eVer
        echo "test install"
        spack find --format '{name}' mu2e-tdaq-suite &>/dev/null || do_build=1
    fi
  fi
fi

if [ $do_build -eq 1 ];then
  echo "Building mu2e-tdaq-$mu2eVer using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir mu2e-tdaq-$mu2eVer;cd mu2e-tdaq-$mu2eVer
  touch .cvmfscatalog
  rm mu2e-quick-spack-start_${spackVer}.sh*
  wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start_${spackVer}.sh && chmod +x mu2e-quick-spack-start_${spackVer}.sh
  ./mu2e-quick-spack-start_${spackVer}.sh --padding --no-kmod --no-emacs --no-view --arch linux-almalinux9-x86_64_v3 --tag $mu2eVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer
  cleanup
else
  echo "mu2e-tdaq-$mu2eVer is up to date, no build needed"
  touch .build_verified
fi

git config --global --unset-all safe.directory
