#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/scream || exit
git pull >/dev/null
popd || exit

pushd "$PWD"/packages/scream/Receivers/pulseaudio-ivshmem || exit
rm -f ./scream-ivshmem-pulse
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo cp -f ./scream-ivshmem-pulse /usr/bin/scream-ivshmem-pulse
popd || exit
