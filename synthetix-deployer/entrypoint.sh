#!/bin/bash

# For test deployments only

# Copyright Optimism PBC 2021
# MIT License
# github.com/ethereum-optimism

DIR=$1
if [ -z $DIR ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
fi

cd $DIR

node $DIR/publish deploy-ovm-pair \
    --l1-provider-url $L1_NODE_WEB3_URL \
    --l2-provider-url $L2_NODE_WEB3_URL \
    --data-provider-url $DEPLOYER_HTTP

echo "Starting HTTP server on $SERVER_PORT"
DEPLOYMENT_PATH="$DIR/publish/deployed/local"
python \
    -m http.server \
    --bind 0.0.0.0 $SERVER_PORT \
    --directory $DEPLOYMENT_PATH
