#!/bin/bash
set -e
mkdir -p private

if [ "$#" -ne 1 ]; then
    echo "Exact 1 argument required: config path or mainnet/testnet"
    exit 1
fi

if [ "$1" == 'testnet' ]; then
    wget -q -O private/testnet.json https://ton.org/testnet-global.config.json
    echo "Downloading testnet global config file"
    GLOBAL_CONFIG=private/testnet.json
elif [ "$1" == 'mainnet' ]; then
    wget -q -O private/mainnet.json https://ton.org/global.config.json
    echo "Downloading mainnet global config file"
    GLOBAL_CONFIG=private/mainnet.json
else
    echo "Using custom config file: '$1'"
    GLOBAL_CONFIG=$1
fi

PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
echo "Detected public IP: ${PUBLIC_IP}"

cat <<EOF > .env
TON_STORAGE_ADNL_PORT=${TON_STORAGE_ADNL_PORT:-3333}
TON_STORAGE_CONTROL_PORT=${TON_STORAGE_CONTROL_PORT:-5555}
TON_STORAGE_VERBOSITY_LEVEL=${TON_STORAGE_VERBOSITY_LEVEL:-1}
TON_STORAGE_PUBLIC_IP=$PUBLIC_IP
TON_STORAGE_GLOBAL_CONFIG=$GLOBAL_CONFIG
TON_STORAGE_DATABASE_NAME=${TON_STORAGE_DATABASE_NAME:-/var/ton-storage}

TON_STORAGE_GATEWAY_PORT=${TON_STORAGE_GATEWAY_PORT:-3000}
TON_STORAGE_GATEWAY_DOMAIN=${TON_STORAGE_GATEWAY_DOMAIN:-domain.ton}
TON_STORAGE_GATEWAY_CONFIG=${TON_STORAGE_GATEWAY_CONFIG:-private/config.js}
EOF

echo "!!! Put your gateway config.js to '${TON_STORAGE_GATEWAY_CONFIG:-private/config.js}' file !!!"
