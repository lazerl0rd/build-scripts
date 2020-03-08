#!/usr/bin/env bash

export QTDIR=/usr/lib/x86_64-linux-gnu/qt5
export PATH=/usr/lib/x86_64-linux-gnu/qt5/bin:/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/kipi-plugins || exit
git pull >/dev/null
rm -rf ./build
mkdir -p ./build
cd ./build
cmake -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/usr ..
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit
