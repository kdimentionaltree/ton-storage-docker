# TON Storage Docker

This container contains two tasks:
- Storage daemon.
- Storage gateway.

## Running docker
* First time configuration: `./init.sh mainnet` or `./init.sh testnet`.
* (WIP) Put your `config.js` to `private/config.js` file.
* Check `.env` file and change settings.
* Build: `docker-compose build`.
* Run: `docker-compose up -d`.

## Storage settings
Most part of settings are located in `.env`.

### Storage daemon settings
* `TON_STORAGE_ADNL_PORT=3333`: a port for ADNL queries.
* `TON_STORAGE_CONTROL_PORT=5555`: a control port.
* `TON_STORAGE_VERBOSITY_LEVEL=1`: verbosity level (3 is recommended for debug, 4 is full debug).
* `TON_STORAGE_PUBLIC_IP=116.202.116.162`: your public IP (should be detected automatically).
* `TON_STORAGE_GLOBAL_CONFIG`: global config (set by `init.sh` stript).
* `TON_STORAGE_DATABASE_NAME=/var/ton-storage`: database name (recommended to use default value).

### (WIP) Storage gateway settings
* `TON_STORAGE_GATEWAY_CONFIG=private/config.js`: path to config.js (set by `init.sh`).
* `TON_STORAGE_GATEWAY_PORT=3000`: WIP.
* `TON_STORAGE_GATEWAY_DOMAIN=domain.ton`: WIP.
