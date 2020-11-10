#!/bin/bash

# Copyright Optimism PBC 2020
# MIT License
# github.com/ethereum-optimism

cmd="$@"
JSON='{"jsonrpc":"2.0","id":0,"method":"net_version","params":[]}'
SYNTHETIX_TARGET=${SYNTHETIX_TARGET:-'L2'}

# This script is generalized to work with either L1 or L2.
NODE_WEB3_URL=$NODE_WEB3_URL
if [[ "$SYNTHETIX_TARGET" == "L2" ]]; then
    NODE_WEB3_URL=$L2_NODE_WEB3_URL
elif [[ "$SYNTHETIX_TARGET" == "L1" ]]; then
    NODE_WEB3_URL=$L1_NODE_WEB3_URL
fi

RETRIES=20
until $(curl --silent --fail \
    --output /dev/null \
    -H "Content-Type: application/json" \
    --data "$JSON" "$NODE_WEB3_URL"); do
  sleep 1
  echo "Will wait $((RETRIES--)) more times for $NODE_WEB3_URL to be up..."

  if [ "$RETRIES" -lt 0 ]; then
    echo "Timeout waiting for remote node at $NODE_WEB3_URL"
    exit 1
  fi
done

echo "Connected to Remote Node at $NODE_WEB3_URL"

# Register the contracts with hardhat if the backend is hardhat
if [[ ! -z "$HARDHAT" && "$SYNTHETIX_TARGET" == "L1" ]]; then
    BUILD_DIR=/opt/synthetix/build
    METHOD="hardhat_addCompilationResult"
    VERSION=$(cat $BUILD_DIR/cache/last-solc-config.json | jq -r .solc.version)
    INPUT=$(cat $BUILD_DIR/cache/solc-input.json)
    OUTPUT=$(cat $BUILD_DIR/cache/solc-output.json)
    DATA='{"jsonrpc":"2.0","method":"'$METHOD'","params":["'$VERSION'",'"$INPUT"','"$OUTPUT"'],"id":0}'
    echo "$DATA" | curl --silent --output /dev/null -X POST \
        -H 'Content-Type: application/json' \
        --data @- \
        $NODE_WEB3_URL
fi

exec env \
    NODE_WEB3_URL=$NODE_WEB3_URL \
    $cmd
