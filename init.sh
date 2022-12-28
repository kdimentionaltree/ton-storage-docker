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
TON_STORAGE_GLOBAL_CONFIG=$GLOBAL_CONFIG
TON_STORAGE_DATABASE_NAME=${TON_STORAGE_DATABASE_NAME:-ton-storage}

TON_STORAGE_GATEWAY_PORT=${TON_STORAGE_GATEWAY_PORT:-3000}
TON_STORAGE_GATEWAY_DOMAIN=${TON_STORAGE_GATEWAY_DOMAIN:-domain.ton}
TON_STORAGE_GATEWAY_CONFIG=${TON_STORAGE_GATEWAY_CONFIG:-private/config.js}

TON_PUBLIC_IP=$PUBLIC_IP

TON_PROXY_ENABLED=${TON_PROXY_ENABLED:-0}
TON_PROXY_PORT=${TON_PROXY_PORT:-8080}
TON_PROXY_ADNL_PORT=${TON_PROXY_ADNL_PORT:-3334}
TON_PROXY_VERBOSITY_LEVEL=${TON_PROXY_VERBOSITY_LEVEL:-3}
TON_PROXY_GLOBAL_CONFIG=private/mainnet.json

EOF

if [ "$TON_PROXY_ENABLED" = 1 ]; then
    echo "COMPOSE_FILE=docker-compose.yaml:docker-compose.proxy.yaml" >> .env
    if [ ! -f "private/adnl" ]; then
        echo "Generating proxy ADNL addr"
        docker compose -f docker-compose.proxy.yaml build
        docker run --rm -v `pwd`/private:/output localhost:5000/ton-proxy:latest ./generate_adnl.sh
    else
        echo "Proxy ADNL addr exists"
    fi
    echo "ADNL_HEX: $(cat private/adnl-hex), ADNL: $(cat private/adnl)"
fi

echo "!!! Put your gateway config.js to '${TON_STORAGE_GATEWAY_CONFIG:-private/config.js}' file !!!"
