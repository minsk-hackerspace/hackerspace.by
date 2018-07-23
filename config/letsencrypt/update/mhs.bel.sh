#!/bin/sh

/home/mhs/letsencrypt/certbot/certbot-auto certonly \
    --standalone \
    --email info@hackerspace.by \
    --renew-by-default \
    --rsa-key-size 4096 \
    -d xn--l1akl.xn--90ais \
    -d www.xn--l1akl.xn--90ais \
    --pre-hook 'systemctl stop nginx' \
    --post-hook 'systemctl start nginx'
