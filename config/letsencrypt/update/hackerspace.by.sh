#!/bin/sh

/home/user/letsencrypt/certbot/certbot-auto certonly \
    --standalone \
    --email info@hackerspace.by \
    --renew-by-default \
    --rsa-key-size 4096 \
    -d hackerspace.by \
    -d www.hackerspace.by \
    -d calendar.hackerspace.by \
    --pre-hook 'systemctl stop nginx' \
    --post-hook 'systemctl start nginx'
