#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/packages/piper || exit
git pull >/dev/null
rm -rf ./builddir
mkdir -p ./builddir
CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" meson ./builddir --prefix=/usr/
ninja -C ./builddir
sudo ninja -C ./builddir install
popd || exit
