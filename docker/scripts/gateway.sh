#!/bin/bash
set -e

echo "waiting for 2 seconds before start"
sleep 2
echo "Starting"

cat <<EOF > .env
SERVER_PORT=${TON_STORAGE_GATEWAY_PORT:-3000}
SERVER_HOST="0.0.0.0"
SERVER_HOSTNAME="${TON_STORAGE_GATEWAY_DOMAIN:-domain.ton}"

TONSTORAGE_BIN="/usr/local/bin/storage-daemon-cli"
TONSTORAGE_HOST="127.0.0.1:${TON_STORAGE_CONTROL_PORT:-5555}"
TONSTORAGE_DATABASE="/data/${TON_STORAGE_DATABASE_NAME:-ton-storage}"
TONSTORAGE_TIMEOUT=5000

SESSION_COOKIE_NAME="sid"
SESSION_COOKIE_PASSWORD="cookiepassword"
SESSION_COOKIE_PATH="/"
SESSION_COOKIE_ISSECURE=false

GITHUB_AUTH_PASSWORD="authpassword"
GITHUB_AUTH_CLIENTID="authcliendid"
GITHUB_AUTH_CLIENTSECRET="authclientsecret"
GITHUB_AUTH_ISSECURE=false
EOF

echo "ENV:"
cat .env

node src/index.js
