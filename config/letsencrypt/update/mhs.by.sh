#!/bin/sh

/home/mhs/letsencrypt/certbot/certbot-auto certonly \
    --standalone \
    --email info@hackerspace.by \
    --renew-by-default \
    --rsa-key-size 4096 \
    -d mhs.by \
    -d www.mhs.by \
    -d calendar.mhs.by \
    -d calendar.green.mhs.by \
    -d calendar.malino.mhs.by \
    --pre-hook 'systemctl stop nginx' \
    --post-hook 'systemctl start nginx'
