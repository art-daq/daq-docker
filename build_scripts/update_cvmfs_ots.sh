
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

otsVer=${1:-v2_09_01}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

echo "Building ots-$otsVer"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir ots-$otsVer;cd ots-$otsVer
touch .cvmfscatalog
rm ots-quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start.sh && chmod +x ots-quick-spack-start.sh
./ots-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $otsVer
cleanup
