#!/bin/sh

MHS_CURRENT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
MHS_UPDATE_DIR="$MHS_CURRENT_DIR/update/"

for f in $(ls "$MHS_UPDATE_DIR"); do
    "$MHS_UPDATE_DIR$f"
done
