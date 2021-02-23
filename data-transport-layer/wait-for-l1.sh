#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
JSON='{"jsonrpc":"2.0","id":0,"method":"eth_chainId","params":[]}'
L1_NODE_WEB3_URL=$DATA_TRANSPORT_LAYER__L1_RPC_ENDPOINT
L2_NODE_WEB3_URL=$DATA_TRANSPORT_LAYER__L2_RPC_ENDPOINT
DATA_TRANSPORT_LAYER__L2_CHAIN_ID=$DATA_TRANSPORT_LAYER__L2_CHAIN_ID

if [[ "$DATA_TRANSPORT_LAYER__SYNC_FROM_L1" == true ]]; then
    if [[ -z "$L1_NODE_WEB3_URL" ]]; then
        echo "Missing DATA_TRANSPORT_LAYER__L1_RPC_ENDPOINT env var"
        exit 1
    fi
fi

RETRIES=${RETRIES:-20}
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

if [[ "$DATA_TRANSPORT_LAYER__SYNC_FROM_L2" == true ]]; then
    if [[ -z "$L2_NODE_WEB3_URL" ]]; then
        echo "Missing DATA_TRANSPORT_LAYER__L2_RPC_ENDPOINT env var"
        exit 1
    fi

    RETRIES=${RETRIES:-20}
    until $(curl --silent --fail \
        --output /dev/null \
        -H "Content-Type: application/json" \
        --data "$JSON" "$L2_NODE_WEB3_URL"); do
      sleep 1
      echo "Will wait $((RETRIES--)) more times for $L2_NODE_WEB3_URL to be up..."

      if [ "$RETRIES" -lt 0 ]; then
        echo "Timeout waiting for layer one node at $L2_NODE_WEB3_URL"
        exit 1
      fi
    done
    echo "Connected to L2 Node at $L2_NODE_WEB3_URL"

    DATA_TRANSPORT_LAYER__L2_CHAIN_ID=$(curl --silent -H \
        "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","id":0,"method":"eth_chainId","params":[]}' \
        "$L2_NODE_WEB3_URL" | jq -r .result | xargs printf '%d')
fi

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

    DATA_TRANSPORT_LAYER__ADDRESS_MANAGER=$(curl --silent $DEPLOYER_HTTP/addresses.json | jq -r .AddressManager)
    exec env \
        DATA_TRANSPORT_LAYER__ADDRESS_MANAGER=$DATA_TRANSPORT_LAYER__ADDRESS_MANAGER \
        DATA_TRANSPORT_LAYER__L2_CHAIN_ID=$DATA_TRANSPORT_LAYER__L2_CHAIN_ID \
        $cmd
else
    exec $cmd
fi
