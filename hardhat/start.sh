#!/bin/bash

ETH1_HTTP_PORT=${ETH1_HTTP_PORT:-9545}

npx hardhat node --hostname 0.0.0.0 --port $ETH1_HTTP_PORT
