
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

mu2eVer=${1:-v3_03_01}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

echo "Building mu2e-tdaq-$mu2eVer"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir mu2e-tdaq-$mu2eVer;cd mu2e-tdaq-$mu2eVer
touch .cvmfscatalog
rm mu2e-quick-spack-start.sh*;wget https://raw.githubusercontent.com/Mu2e/otsdaq_mu2e/refs/heads/develop/tools/mu2e-quick-spack-start.sh && chmod +x mu2e-quick-spack-start.sh
./mu2e-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $mu2eVer
cleanup
