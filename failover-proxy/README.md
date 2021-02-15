# Failover Proxy

This is a failover proxy that is meant to provide redundency for HTTP
requests to multiple data providers that provide the same data. It
depends on a single environment variable `SERVICES` which is a comma
separated string of URLs. The first item is the main backend to be queried
and any subsequent backends will be used as fallbacks.

It is currently configured to listen on port `8545` because it is being used
to provide redundency for Ethereum providers.

To build the failover proxy, use the command:

```bash
$ ./build.sh -s failover-proxy
```

To run:

```bash
$ docker run --rm -p 8545:8545 \
    -e "SERVICES=http://my-eth-1-provider,http://my-backup" \
    ethereumoptimism/failover-proxy:latest
```
