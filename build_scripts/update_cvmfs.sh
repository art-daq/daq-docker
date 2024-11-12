cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

artVer=132
artdaqVer=v3_14_01
otsVer=v2_09_00

function cleanup() {
    echo "Cleaning build area"
    source setup-env.sh
    spack reindex
    rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
}

echo "Building art-suite-s$artVer"
mkdir art-suite-s$artVer;cd art-suite-s$artVer
touch .cvmfscatalog
rm art-suite-spack-start.sh;wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/art-suite-spack-start.sh && chmod +x art-suite-spack-start.sh
./art-suite-spack-start.sh --padding --no-view -s $artVer --arch linux-almalinux9-x86_64_v3
cleanup

echo "Building artdaq-$artdaqVer"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir artdaq-$artdaqVer;cd artdaq-$artdaqVer
touch .cvmfscatalog
rm quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start.sh && chmod +x quick-spack-start.sh
./quick-spack-start.sh --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-s$artVer --tag $artdaqVer --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3
cleanup

echo "Building ots-$otsVer"
cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
mkdir ots-$otsVer;cd ots-$otsVer
touch .cvmfscatalog
rm ots-quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start.sh && chmod +x ots-quick-spack-start.sh
./ots-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 --tag $otsVer --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-s$artVer --upstream  /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$artdaqVer
cleanup
