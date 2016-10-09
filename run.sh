#!/bin/sh

cd /home/mhs/www/current && \
rvm use $(cat ./.ruby-version)

bundle install && \
bundle exec puma -e production -b unix:///home/mhs/www/current/tmp/sockets/puma.sock &
