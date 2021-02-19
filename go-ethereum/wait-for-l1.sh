#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
if [ -z "$ROLLUP_CLIENT_HTTP" ]; then
    echo "Missing ROLLUP_CLIENT_HTTP env var"
fi

RETRIES=${RETRIES:-20}
until $(curl --silent --fail \
    --output /dev/null \
    "$ROLLUP_CLIENT_HTTP/eth/syncing"); do
  sleep 1
  echo "Will wait $((RETRIES--)) more times for $ROLLUP_CLIENT_HTTP to be up..."

  if [ "$RETRIES" -lt 0 ]; then
    echo "Timeout waiting for layer one node at $ROLLUP_CLIENT_HTTP"
    exit 1
  fi
done

if [ ! -z "$DEPLOYER_HTTP" ]; then
    RETRIES=${RETRIES:-20}
    until $(curl --silent --fail \
        --output /dev/null \
        "$DEPLOYER_HTTP/addresses.json"); do
      sleep 1
      echo "Will wait $((RETRIES--)) more times for $DEPLOYER_HTTP to be up..."

      if [ "$RETRIES" -lt 0 ]; then
        echo "Timeout waiting for address list from $DEPLOYER_HTTP"
        exit 1
      fi
    done
    echo "Received address list from $DEPLOYER_HTTP"

    ETH1_ADDRESS_RESOLVER_ADDRESS=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .AddressManager)
    ETH1_L1_CROSS_DOMAIN_MESSENGER_ADDRESS=$(curl --silent \
        $DEPLOYER_HTTP/addresses.json | jq -r .Proxy__OVM_L1CrossDomainMessenger)
    ETH1_L1_ETH_GATEWAY_ADDRESS=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .OVM_L1ETHGateway)
    ROLLUP_ADDRESS_MANAGER_OWNER_ADDRESS=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .Deployer)

    exec env \
        ETH1_ADDRESS_RESOLVER_ADDRESS=$ETH1_ADDRESS_RESOLVER_ADDRESS \
        ETH1_L1_CROSS_DOMAIN_MESSENGER_ADDRESS=$ETH1_L1_CROSS_DOMAIN_MESSENGER_ADDRESS \
        ETH1_L1_ETH_GATEWAY_ADDRESS=$ETH1_L1_ETH_GATEWAY_ADDRESS \
        ROLLUP_ADDRESS_MANAGER_OWNER_ADDRESS=$ROLLUP_ADDRESS_MANAGER_OWNER_ADDRESS \
        $cmd
else
    exec $cmd
fi
