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

function verify() {
    if ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/mu2e-tdaq-$mu2eVer-al${osVer} ]; then
        echo "Build area does not exist, cannot verify build"
        return 1
    fi

    res=0
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/mu2e-tdaq-$mu2eVer-al${osVer}
    if ! [ -f .build_verified ]; then
        echo "Verifying build, setting up Spack"
        source setup-env.sh
        echo "activate tdaq-$mu2eVer-al${osVer}"
        spack env activate tdaq-$mu2eVer-al${osVer}
        echo "test install"
        spack find --format '{name}' mu2e-tdaq-suite &>/dev/null || res=1
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
if ! [ -f /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer-al${osVer}/.build_verified ]; then
    echo "Dependency ots-$otsVer-al${osVer} not built; please run update_cvmfs_ots.sh first."
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
  echo "Building mu2e-tdaq-$mu2eVer using Spack $spackVer on Alma$osVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}
  mkdir mu2e-tdaq-$mu2eVer-al${osVer}
  cd mu2e-tdaq-$mu2eVer-al${osVer}
  touch .cvmfscatalog
  rm .build_verified
  rm mu2e-quick-spack-start_${spackVer}.sh*
  wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start_${spackVer}.sh && chmod +x mu2e-quick-spack-start_${spackVer}.sh
  ./mu2e-quick-spack-start_${spackVer}.sh --padding --no-kmod --no-emacs --no-view --arch linux-almalinux${osVer}-x86_64_v3 --tag $mu2eVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/ots-$otsVer-al${osVer} \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/artdaq-$artdaqVer-al${osVer} \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_${spackVer}/art-suite-$artVer-al${osVer}
  cleanup
  verify
else
  echo "mu2e-tdaq-$mu2eVer-al${osVer} is up to date, no build needed"
fi

git config --global --unset-all safe.directory
