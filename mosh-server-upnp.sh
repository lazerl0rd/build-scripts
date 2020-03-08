#!/usr/bin/env bash

cd /src || exit

pushd "$PWD"/packages/mosh-server-upnp || exit
git pull >/dev/null
cargo clean
cargo build --release
sudo cp -f ./target/release/mosh-server-upnp /usr/bin/mosh-server-upnp
popd || exit
