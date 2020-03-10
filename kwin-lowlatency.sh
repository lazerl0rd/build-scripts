#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/kwin-lowlatency || exit
git pull >/dev/null
rm -rf ./build
mkdir -p ./build
cd ./build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_INSTALL_LIBEXECDIR=lib/x86_64-linux-gnu -DBUILD_TESTING=OFF ..
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -mllvm -polly -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit
