#!/bin/bash

docker images \
    --filter "label=io.optimism.repo=docker" \
    --format='{{.ID}}' \
    | xargs docker rmi -f
