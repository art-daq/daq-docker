cd /cvmfs/fermilab.opensciencegrid.org/products/artdaq/artdaq_spack

rm quick-spack-start.sh* && wget https://raw.githubusercontent.com/art-daq/artdaq_demo/refs/heads/develop/tools/quick-spack-start.sh && chmod +x quick-spack-start.sh
rm ots-quick-spack-start.sh* && wget https://raw.githubusercontent.com/art-daq/otsdaq_demo/refs/heads/develop/tools/ots-quick-spack-start.sh && chmod +x ots-quick-spack-start.sh

./quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3
./ots-quick-spack-start.sh --padding --no-kmod --no-view --arch linux-almalinux9-x86_64_v3

source setup-env.sh
spack reindex

rm -rf daqlogs daqdata CMakeLists.txt* fonts* log qms-log run_records Data databases script_log DAQInterface Data.bak*
