#!/bin/bash

DIR=$1
if [ -z $DIR ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
fi

cd $DIR

DEPLOYMENT_PATH="publish/deployed/test-ovm"

# The config options are currently hard coded
# to only work with `optimism-integration` setup
node $DIR/publish deploy-ovm-pair

echo "Starting HTTP server on $SERVER_PORT"
python \
    -m http.server \
    --bind 0.0.0.0 $SERVER_PORT \
    --directory $DEPLOYMENT_PATH
