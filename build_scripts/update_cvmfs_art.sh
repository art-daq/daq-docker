cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

artVer=${1:-132}
force=${2:-0}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

if [ $force -eq 1 ] || ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-s$artVer ];then
  echo "Building art-suite-s$artVer"
  mkdir art-suite-s$artVer;cd art-suite-s$artVer
  touch .cvmfscatalog
  rm art-suite-spack-start.sh;wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/art-suite-spack-start.sh && chmod +x art-suite-spack-start.sh
  ./art-suite-spack-start.sh --padding --no-view -s $artVer --arch linux-almalinux9-x86_64_v3
  cleanup
fi

git config --global --unset-all safe.directory
