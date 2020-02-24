#!/bin/bash

echo Setup SSH...
echo -e "Host hackerspace.by\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
echo Decrypting SSH key for Travis...
openssl aes-256-cbc -K $encrypted_622d28529b58_key -iv $encrypted_622d28529b58_iv -in deploy_key.enc -out ./deploy_key -d
chmod 600 ./deploy_key
eval "$(ssh-agent -s)"
ssh-add ./deploy_key
ssh -i ./deploy_key mhs@hackerspace.by pwd
#bundle exec mina deploy
bundle exec mina test
