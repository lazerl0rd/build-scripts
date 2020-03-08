#!/usr/bin/env bash

cd /src || exit

pushd "$PWD"/packages/nextcloud-docker || exit
docker build -t nextcloud:custom . --pull
popd || exit
