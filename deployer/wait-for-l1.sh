#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
JSON='{"jsonrpc":"2.0","id":0,"method":"net_version","params":[]}'

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

# Register the contracts with hardhat if the backend is hardhat
if [ ! -z "$HARDHAT" ]; then
    METHOD="hardhat_addCompilationResult"
    VERSION=$(cat /opt/contracts-v2/cache/last-solc-config.json | jq -r .solc.version)
    INPUT=$(cat /opt/contracts-v2/cache/solc-input.json)
    OUTPUT=$(cat /opt/contracts-v2/cache/solc-output.json)
    DATA='{"jsonrpc":"2.0","method":"'$METHOD'","params":["'$VERSION'",'"$INPUT"','"$OUTPUT"'],"id":0}'
    echo "$DATA" | curl --silent --output /dev/null -X POST \
        -H 'Content-Type: application/json' \
        --data @- \
        $L1_NODE_WEB3_URL
fi

RESULT=$(exec $cmd)
echo "$RESULT" | tee /opt/contracts-v2/artifacts/addresses.json

echo "Starting HTTP server on $SERVER_PORT"
python \
    -m http.server \
    --bind 0.0.0.0 $SERVER_PORT \
    --directory /opt/contracts-v2/artifacts
