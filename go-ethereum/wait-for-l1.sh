#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
JSON='{"jsonrpc":"2.0","id":0,"method":"net_version","params":[]}'

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

if [ ! -z "$DEPLOYER_HTTP" ]; then
    RETRIES=20
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
    ETH1_NETWORKID=$(curl --silent -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","id":0,"method":"net_version","params":[]}' \
        "$L1_NODE_WEB3_URL" | jq -r .result)
    ETH1_CHAINID=$(curl --silent -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","id":0,"method":"eth_chainId","params":[]}' \
        "$L1_NODE_WEB3_URL" | jq -r .result | xargs printf '%d')

    exec env \
        ETH1_ADDRESS_RESOLVER_ADDRESS=$ETH1_ADDRESS_RESOLVER_ADDRESS \
        ETH1_L1_CROSS_DOMAIN_MESSENGER_ADDRESS=$ETH1_L1_CROSS_DOMAIN_MESSENGER_ADDRESS \
        ETH1_L1_ETH_GATEWAY_ADDRESS=$ETH1_L1_ETH_GATEWAY_ADDRESS \
        ETH1_NETWORKID=$ETH1_NETWORKID \
        ROLLUP_ADDRESS_MANAGER_OWNER_ADDRESS=$ROLLUP_ADDRESS_MANAGER_OWNER_ADDRESS \
        ETH1_CHAINID=$ETH1_CHAINID \
        $cmd
else
    exec $cmd
fi
