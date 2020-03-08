#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/tuxclocker || exit
git pull >/dev/null
make clean
/usr/lib/x86_64-linux-gnu/qt5/bin/qmake rojekti.pro
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit
