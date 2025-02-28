
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

mu2eVer=${1:-v3_04_00}
force=${2:-0}

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
  ./mu2e-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $mu2eVer
  cleanup
fi

echo "Building mu2e-tdaq-develop"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir mu2e-tdaq-develop;cd mu2e-tdaq-develop
touch .cvmfscatalog
rm mu2e-quick-spack-start.sh*;wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start.sh && chmod +x mu2e-quick-spack-start.sh
./mu2e-quick-spack-start.sh --padding --no-kmod --arch linux-almalinux9-x86_64_v3 --develop --trigger --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/mu2e-tdaq-$mu2eVer
cleanup

git config --global --unset-all safe.directory
