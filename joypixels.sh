#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/joypixels-color-font/SCFBuild || exit
git pull >/dev/null
popd || exit

pushd "$PWD"/packages/joypixels-color-font || exit
git pull >/dev/null
make clean
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
popd || exit
