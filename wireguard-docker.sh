#!/usr/bin/env bash

cd /src || exit

pushd "$PWD"/packages/wireguard-docker || exit
docker build -t wireguard-docker:custom . --pull
popd || exit
