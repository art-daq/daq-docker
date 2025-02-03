cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

artdaqVer=${1:-v3_16_00}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

echo "Building artdaq-$artdaqVer"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir artdaq-$artdaqVer;cd artdaq-$artdaqVer
touch .cvmfscatalog
rm quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start.sh && chmod +x quick-spack-start.sh
./quick-spack-start.sh --tag $artdaqVer --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3
cleanup
