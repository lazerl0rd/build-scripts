#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/comixcursors || exit
git pull >/dev/null
make clean
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit
