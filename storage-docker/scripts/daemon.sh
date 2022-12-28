#!/bin/bash
set -e

printenv

storage-daemon -v ${TON_STORAGE_VERBOSITY_LEVEL:-1} \
               -C ${TON_STORAGE_GLOBAL_CONFIG:?} \
               -I ${TON_STORAGE_PUBLIC_IP:?}:${TON_STORAGE_ADNL_PORT:-3333} \
               -p ${TON_STORAGE_CONTROL_PORT:-5555} \
               -D ${TON_STORAGE_DATABASE_NAME:-/var/ton-storage}
