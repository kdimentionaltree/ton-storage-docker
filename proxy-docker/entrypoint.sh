#!/bin/bash
set -e

ADNL=$(cat /run/secrets/adnl)
ADNL_HEX=$(cat /run/secrets/adnl-hex)

mkdir -p keyring
cat /run/secrets/adnl-private > keyring/$ADNL_HEX
chmod 600 keyring/$ADNL_HEX

echo "Waiting for 5 seconds"
sleep 5

rldp-http-proxy -p ${TON_PROXY_PORT:-8080} \
                -a ${TON_PUBLIC_IP}:${TON_PROXY_ADNL_PORT:-3334} \
                -A ${ADNL} \
                -C ${TON_PROXY_GLOBAL_CONFIG:?} \
                --verbosity ${TON_PROXY_VERBOSITY_LEVEL:-1} \
                -R '*'@127.0.0.1:${TON_STORAGE_GATEWAY_PORT:?}
