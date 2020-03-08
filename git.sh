#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/libraries || exit
rm -rf quiche
git clone --recursive https://github.com/cloudflare/quiche quiche
popd || exit

pushd "$PWD"/libraries/zlib || exit
git pull >/dev/null
[ -f Makefile ] && make clean
make -f Makefile.in distclean
popd || exit

pushd "$PWD"/packages/git || exit
git pull >/dev/null
make clean
autoconf configure.ac > configure
chmod +x configure
CC=clang CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" ./configure --prefix="/usr" --with-openssl="../../libraries/quiche/deps/boringssl" --with-zlib="../../libraries/zlib"

# Hack due to "doc" not building prior to "info".
AR=llvm-ar CXX=clang++ NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make all info -j"$(nproc)"

AR=llvm-ar CXX=clang++ NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make all doc info -j"$(nproc)"
sudo make install
popd || exit
