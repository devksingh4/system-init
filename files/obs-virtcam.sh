#!/bin/bash
cd $HOME
mkdir -p obs_build
cd obs_build
git clone --recursive https://github.com/obsproject/obs-studio.git
git clone https://github.com/CatxFish/obs-v4l2sink
cd obs-v4l2sink
mkdir -p build && cd build
cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
make install
cp /usr/lib/obs-plugins/v4l2sink.so /usr/lib/x86_64-linux-gnu/obs-plugins/
