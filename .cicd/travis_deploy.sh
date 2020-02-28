#!/bin/bash

# enable tracing
set -x

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo [x] Setup SSH...
echo -e "Host hackerspace.by\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
echo Decrypting SSH key for Travis...
openssl aes-256-cbc -K $encrypted_622d28529b58_key -iv $encrypted_622d28529b58_iv -in "$THISDIR/deploy_key.enc" -out "$THISDIR/deploy_key" -d
chmod 600 ./deploy_key
eval "$(ssh-agent -s)"
ssh-add ./deploy_key
ssh -i ./deploy_key mhs@hackerspace.by pwd


echo "[x] Preparing and running 'mina' (Ruby deploy tool)"

bundle install
bundle exec mina deploy

