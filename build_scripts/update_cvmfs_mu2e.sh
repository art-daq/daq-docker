
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

artVer=${artVer:-s132}
artdaqVer=${artdaqVer:-v4_00_00}
otsVer=${otsVer:-v3_00_00}
mu2eVer=${mu2eVer:-v3_04_00}
force=${force:-0}
develop=${develop:-0}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

if [ $force -eq 1 ] || ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/mu2e-tdaq-$mu2eVer ];then
  echo "Building mu2e-tdaq-$mu2eVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
  mkdir mu2e-tdaq-$mu2eVer;cd mu2e-tdaq-$mu2eVer
  touch .cvmfscatalog
  rm mu2e-quick-spack-start.sh*;wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start.sh && chmod +x mu2e-quick-spack-start.sh
  ./mu2e-quick-spack-start.sh --padding --no-kmod --no-emacs --no-view --arch linux-almalinux9-x86_64_v3 --tag $mu2eVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$otsVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$artdaqVer \
                              --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$artVer
  cleanup
fi

if [ $develop -eq 1 ];then
    echo "Building mu2e-tdaq-develop"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
    mkdir mu2e-tdaq-develop;cd mu2e-tdaq-develop
    touch .cvmfscatalog
    rm mu2e-quick-spack-start.sh*;wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start.sh && chmod +x mu2e-quick-spack-start.sh
    ./mu2e-quick-spack-start.sh --padding --no-kmod --no-emacs --arch linux-almalinux9-x86_64_v3 --develop --trigger \
                                --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/mu2e-tdaq-$mu2eVer \
                                --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$otsVer \
                                --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$artdaqVer \
                                --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$artVer
    cleanup
fi

git config --global --unset-all safe.directory
