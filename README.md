# TON Storage Docker

The main container contains two tasks:
- Storage daemon.
- Storage gateway.

Additionaly, you cat run TON proxy container for your gateway.

## Running docker
* First time configuration: `./init.sh mainnet` or `./init.sh testnet`.
    * If you want setup TON proxy: `TON_PROXY_ENABLED=1 ./init.sh <network>`.
    * If you already have ADNL address, then put user-friendly form to `private/adnl`, hex-form to `private/adnl-hex` and private key to `private/adnl-private`.
    * (WARNING) Make a backup of 3 files with ADNL: `private/adnl`, `private/adnl-hex` and `private/adnl-private`.
* Check `.env` file and change settings.
* Build: `docker-compose build`.
* Run: `docker-compose up -d`.

## Uploading content

* Place necessary files to `exchange` folder.
* Connect to docker container: `docker exec -it ton-storage-docker-gateway-1 bash`.
* Run storage-daemon-cli: `storage-daemon-cli -I 127.0.0.1:5555 -k /data/ton-storage/cli-keys/client -p /data/ton-storage/cli-keys/server.pub`.
* Then follow [instructions](https://ton.org/docs/participate/ton-storage/storage-daemon#creating-a-bag-of-files).

## Storage settings
Most part of settings are located in `.env`.

### Storage daemon settings
* `TON_STORAGE_ADNL_PORT=3333`: a port for ADNL queries.
* `TON_STORAGE_CONTROL_PORT=5555`: a control port.
* `TON_STORAGE_VERBOSITY_LEVEL=1`: verbosity level (3 is recommended for debug, 4 is full debug).
* `TON_STORAGE_PUBLIC_IP=116.202.116.162`: your public IP (should be detected automatically).
* `TON_STORAGE_GLOBAL_CONFIG`: global config (set by `init.sh` stript).
* `TON_STORAGE_DATABASE_NAME=ton-storage`: database name (recommended to use default value).

### (WIP) Storage gateway settings
<!-- * `TON_STORAGE_GATEWAY_CONFIG=private/config.js`: path to config.js (set by `init.sh`). -->
* `TON_STORAGE_GATEWAY_PORT=3000`: requi.
* `TON_STORAGE_GATEWAY_DOMAIN=domain.ton`: WIP.

### Proxy settings
* `TON_PROXY_ENABLED=0`: enables rldp-http-proxy.
* `TON_PROXY_PORT=8080`: port to http connections to proxy.
* `TON_PROXY_ADNL_PORT=3334`: port to adnl queries (must differs with adnl-port of Storage).
* `TON_PROXY_VERBOSITY_LEVEL=1`: verbosity level.
* `TON_PROXY_GLOBAL_CONFIG=private/mainnet.json`: global config path.


## FAQ
1. How to check if TON proxy is working:
    * Get your public IP.
    * In terminal: `curl -v -x <yout-ip>:8080 http://<adnl-userfrienly-form>.adnl/`.
        * If you get HTML code, then it works with your proxy.
    * In terminal: `curl -v -x in1.ton.org:8080 http://<adnl-userfrienly-form>.adnl/`.
        * If not works, then try `in2.ton.org:8080` and `in3.ton.org:8080`.
        * If you get HTML code, then it works with public proxies.
