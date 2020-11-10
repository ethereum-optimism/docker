#!/bin/bash

PREFIX=${1:-$HOME}
DIR="$PREFIX"

if [[ "$SYNTHETIX_TARGET" == "L1" ]]; then
    DIR="$DIR/synthetix"
elif [[ "$SYNTHETIX_TARGET" == "L2"  ]]; then
    DIR="$DIR/synthetix-ovm"
fi

if [ ! -d $DIR ]; then
    echo "Warning: expected $DIR to exist"
fi

cd $DIR

# TODO: what is the difference between these?
DEPLOY_PRIVATE_KEY=$DEPLOYER_PRIVATE_KEY_2
TESTNET_DEPLOY_PRIVATE_KEY=$DEPLOYER_PRIVATE_KEY_2

ETHERSCAN_KEY=$ETHERSCAN_KEY
INFURA_PROJECT_ID=$INFURA_PROJECT_ID
PROVIDER_URL=$NODE_WEB3_URL
DEPLOYMENT_PATH="publish/deployed/test-ovm"
NETWORK="local"
METHOD_CALL_GAS_LIMIT=2000000
ORACLE_ADDRESS=0x9Ac39569e3E9939C2778867f5F0802Da8854685A

# default to L2 amount
CONTRACT_DEPLOYMENT_GAS_LIMIT=${CONTRACT_DEPLOYMENT_GAS_LIMIT:-11000000}
if [[ "$SYNTHETIX_TARGET" == "L1"  ]]; then
    CONTRACT_DEPLOYMENT_GAS_LIMIT=9500000
fi

cmd="node publish deploy"
cmd="$cmd --fresh-deploy --network $NETWORK"
cmd="$cmd --deployment-path $DEPLOYMENT_PATH"
cmd="$cmd --provider-url $PROVIDER_URL"
cmd="$cmd --deployment-path $DEPLOYMENT_PATH"
cmd="$cmd --provider-url $PROVIDER_URL"
cmd="$cmd --method-call-gas-limit $METHOD_CALL_GAS_LIMIT"
cmd="$cmd --contract-deployment-gas-limit $CONTRACT_DEPLOYMENT_GAS_LIMIT"
cmd="$cmd -o $ORACLE_ADDRESS"
cmd="$cmd --yes"

if [[ "$SYNTHETIX_TARGET" == "L2" ]]; then
    cmd="$cmd --use-ovm"
fi

echo "Running $cmd"

env \
    ETHERSCAN_KEY=$ETHERSCAN_KEY\
    INFURA_PROJECT_ID=$INFURA_PROJECT_ID \
    DEPLOY_PRIVATE_KEY=$DEPLOY_PRIVATE_KEY \
    TESTNET_DEPLOY_PRIVATE_KEY=$TESTNET_DEPLOY_PRIVATE_KEY \
        $cmd

echo "Starting HTTP server on $SERVER_PORT"
python \
    -m http.server \
    --bind 0.0.0.0 $SERVER_PORT \
    --directory $DEPLOYMENT_PATH
