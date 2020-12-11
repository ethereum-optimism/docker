#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
JSON='{"jsonrpc":"2.0","id":0,"method":"eth_chainId","params":[]}'

RETRIES=20
until $(curl --silent --fail \
    --output /dev/null \
    -H "Content-Type: application/json" \
    --data "$JSON" "$L1_NODE_WEB3_URL"); do
  sleep 1
  echo "Will wait $((RETRIES--)) more times for $L1_NODE_WEB3_URL to be up..."

  if [ "$RETRIES" -lt 0 ]; then
    echo "Timeout waiting for layer one node at $L1_NODE_WEB3_URL"
    exit 1
  fi
done
echo "Connected to L1 Node at $L1_NODE_WEB3_URL"

RETRIES=20
until $(curl --silent --fail \
    --output /dev/null \
    "$DEPLOYER_HTTP/addresses.json"); do
  sleep 1
  echo "Will wait $((RETRIES--)) more times for $DEPLOYER_HTTP to be up..."

  if [ "$RETRIES" -lt 0 ]; then
    echo "Timeout waiting for contract deployment"
    exit 1
  fi
done
echo "Contracts are deployed"

RETRIES=30
until $(curl --silent --fail \
    --output /dev/null \
    -H "Content-Type: application/json" \
    --data "$JSON" "$L2_NODE_WEB3_URL"); do
  sleep 1
  echo "Will wait $((RETRIES--)) more times for $L2_NODE_WEB3_URL to be up..."

  if [ "$RETRIES" -lt 0 ]; then
    echo "Timeout waiting for layer two node at $L2_NODE_WEB3_URL"
    exit 1
  fi
done
echo "Connected to L2 Node at $L2_NODE_WEB3_URL"


ETH1_ADDRESS_RESOLVER_ADDRESS=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .AddressManager)
L1_MESSENGER_ADDRESS=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .Proxy__OVM_L1CrossDomainMessenger)

exec env \
    ETH1_ADDRESS_RESOLVER_ADDRESS=$ETH1_ADDRESS_RESOLVER_ADDRESS \
    L1_MESSENGER_ADDRESS=$L1_MESSENGER_ADDRESS \
    $cmd
