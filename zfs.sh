#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/zfs || exit
git pull >/dev/null
make clean
sh autogen.sh
CC=clang CFLAGS="-O3 -march=native -mllvm -polly -Wp,-D_FORTIFY_SOURCE=2" ./configure
AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -s -j$(nproc)

# Hack to work around ZFS re-configuring during DEB package building.
export CC=clang CFLAGS="-O3 -march=native -mllvm -polly -Wp,-D_FORTIFY_SOURCE=2"

AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -mllvm -polly -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make deb
rm -rf *dracut*.deb
rm -rf *kmod*.deb
rm -rf *test*.deb
sudo apt install ./*.deb
sudo apt reinstall ./*.deb
popd || exit
