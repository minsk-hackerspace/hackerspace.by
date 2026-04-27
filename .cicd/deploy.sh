#!/bin/bash

# enable tracing
set -x

# fail on first error
set -e

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
KEYPATH="$THISDIR/deploy_key"

echo [x] Setup SSH...
echo -e "Host hackerspace.by\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
echo Adding key to SSH agent...
echo "$SSH_PRIVATE_KEY" > "$KEYPATH"
chmod 600 "$KEYPATH"
eval "$(ssh-agent -s)"
ssh-add "$KEYPATH"
ssh -i "$KEYPATH" user@hackerspace.by pwd


echo "[x] Preparing and running 'mina' (Ruby deploy tool)"

gem install mina
mina deploy

