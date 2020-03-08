#!/usr/bin/env bash

export PATH=/src/tools/clang/bin:$PATH

cd /src || exit

pushd "$PWD"/libraries || exit
rm -rf quiche
git clone --recursive https://github.com/cloudflare/quiche quiche
popd || exit

pushd "$PWD"/libraries/liburing || exit
git pull >/dev/null
make clean
CC=clang CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" ./configure
AR=llvm-ar CXX=clang++ NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit

pushd "$PWD"/libraries/zlib || exit
git pull >/dev/null
[ -f Makefile ] && make clean
make -f Makefile.in distclean
popd || exit

pushd "$PWD"/packages/nginx || exit
git pull >/dev/null
make clean
./auto/configure --prefix="/var/www" --sbin-path="/usr/sbin/nginx" --conf-path="/etc/nginx/nginx.conf" --error-log-path="/var/log/nginx/error.log" --pid-path="/var/run/nginx.pid" --http-log-path="/var/log/nginx/access.log" --http-client-body-temp-path="/tmp/client_body_temp" --http-proxy-temp-path="/tmp/proxy_temp" --http-fastcgi-temp-path="/tmp/fastcgi_temp" --http-uwsgi-temp-path="/tmp/uwsgi_temp" --http-scgi-temp-path="/tmp/scgi_temp" --user="www-data" --group="www-data" --with-cc-opt="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2 -DTCP_FASTOPEN=23" --with-http_ssl_module --with-http_v2_module --with-http_v2_hpack_enc --with-http_v3_module --with-openssl="../../libraries/quiche/deps/boringssl" --with-openssl-opt="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" --with-quiche="../../libraries/quiche" --with-file-aio --with-threads --add-module="../../libraries/ngx_brotli" --add-module="../../libraries/ngx_cookie_flag_module" --with-zlib="../../libraries/zlib" --with-zlib-opt="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" --with-libatomic
AR=llvm-ar CC=clang CXX=clang++ CFLAGS="-O3 -march=native -Wp,-D_FORTIFY_SOURCE=2" NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip make -j"$(nproc)"
sudo make install
popd || exit
