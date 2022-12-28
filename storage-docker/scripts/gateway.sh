#!/bin/bash
set -e

printenv
echo "waiting for 10 seconds before start"
sleep 10
echo "Starting"

cp ${TON_STORAGE_GATEWAY_CONFIG:?} /app/src/config.js
node src/index.js
