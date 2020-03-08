#!/usr/bin/env bash

cd /src || exit

pushd "$PWD"/packages/cya || exit
git pull >/dev/null
sudo cp -f ./cya /usr/bin/cya
sudo cp -f ./cya_completion /etc/bash_completion.d/cya_completion
popd || exit
