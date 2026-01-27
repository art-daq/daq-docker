
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

artVer=${artVer:-s132}
artdaqVer=${artdaqVer:-v4_00_00}
otsVer=${otsVer:-v3_00_00}
force=${force:-0}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

if [ $force -eq 1 ] || ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/ots-$otsVer ];then
  echo "Building ots-$otsVer"
  cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
  mkdir ots-$otsVer;cd ots-$otsVer
  touch .cvmfscatalog
  rm ots-quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start.sh && chmod +x ots-quick-spack-start.sh
  ./ots-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $otsVer \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$artdaqVer \
                             --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$artVer
  cleanup
fi

git config --global --unset-all safe.directory
