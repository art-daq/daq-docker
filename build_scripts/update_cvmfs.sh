cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack

./quick-spack-start.sh --padding --no-kmod --arch linux-almalinux9-x86_64_v3
./ots-quick-spack-start.sh --padding --no-kmod --arch linux-almalinux9-x86_64_v3

source setup-env.sh
spack reindex

rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
