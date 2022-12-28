#!/bin/bash
set -e

echo "waiting for 2 seconds before start"
sleep 2
echo "Starting"

cp ${TON_STORAGE_GATEWAY_CONFIG:?} /app/src/config.js
node src/index.js
