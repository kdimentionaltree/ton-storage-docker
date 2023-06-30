#!/bin/bash

set -e

cmd="/usr/local/bin/storage-daemon-cli"
args='-I 127.0.0.1:5555 -k /data/ton-storage/cli-keys/client -p /data/ton-storage/cli-keys/server.pub'

echo "$args"
# run
docker compose exec -it gateway /usr/local/bin/storage-daemon-cli -I 127.0.0.1:5555 -k /data/ton-storage/cli-keys/client -p /data/ton-storage/cli-keys/server.pub
