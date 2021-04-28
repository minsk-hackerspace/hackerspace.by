#!/bin/bash

# Docker entrypoint file to clean up server.pid on restart
# https://docs.docker.com/compose/rails/

set -e

rm -f /app/tmp/pids/server.pid

exec "$@"
