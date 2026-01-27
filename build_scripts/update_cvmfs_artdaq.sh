cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas

git config --global --add safe.directory '*'

artVer=${artVer:-s132}
artdaqVer=${artdaqVer:-v4_00_00}
force=${force:-0}

function cleanup() {
    (
        echo "Cleaning build area"
        source setup-env.sh
        spack reindex
        rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
    )
}

if [ $force -eq 1 ] || ! [ -d /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/artdaq-$artdaqVer ];then
    echo "Building artdaq-$artdaqVer"
    cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas
    mkdir artdaq-$artdaqVer;cd artdaq-$artdaqVer
    touch .cvmfscatalog
    rm quick-spack-start.sh*;wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start.sh && chmod +x quick-spack-start.sh
    ./quick-spack-start.sh --tag $artdaqVer --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3 \
                           --upstream /cvmfs/fermilab.opensciencegrid.org/products/artdaq/spack_areas/art-suite-$artVer
    cleanup
fi

git config --global --unset-all safe.directory
