#!/bin/bash

# build.sh - build docker images
# Copyright 2020 Optimism PBC
# MIT License

USAGE="
$ ./scripts/build.sh
Build docker images from git branches.
CLI Arguments:
  -b|--branch    - git branch to build
  -s|--service   - service to build
  -o|--org       - docker org used for tag
  -t|--tag       - docker tag for image
  -h|--help      - help message

Default values for branche is master.
"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
ORG=ethereumoptimism
SERVICE=""
GIT_BRANCH=master
TAG=$GIT_BRANCH

while (( "$#" )); do
  case "$1" in
    -b|--branch)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        GIT_BRANCH="$2"
        TAG=$GIT_BRANCH
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -s|--service)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        SERVICE="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -o|--org)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ORG="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -t|--tag)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        TAG="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -h|--help)
      echo "$USAGE"
      exit 0
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

# TODO: tag flag not working when also passing a branch

if [ -n "$SERVICE" ]; then
    docker build \
        --label "io.optimism.repo=docker" \
        --label "io.optimism.repo.git.branch=$GIT_BRANCH" \
        --build-arg BRANCH=$GIT_BRANCH \
        -f $DIR/$SERVICE/Dockerfile \
        -t $ORG/$SERVICE:$TAG $DIR/$SERVICE

    if [ $TAG == 'master' ]; then
        docker tag $ORG/$SERVICE:$TAG $ORG/$SERVICE:latest
    fi
else
    SERVICES=$(cd $DIR; echo */ | tr -d '/' | tr ' ' '\n')
    while read -r SERVICE; do
        docker build \
            --label "io.optimism.repo=docker" \
            --label "io.optimism.repo.git.branch=$GIT_BRANCH" \
            --build-arg BRANCH=$GIT_BRANCH \
            -f "$DIR/$SERVICE/Dockerfile" \
            -t "$ORG/$SERVICE:$TAG" "$DIR/$SERVICE"

        if [ "$TAG" == 'master' ]; then
            docker tag "$ORG/$SERVICE:$TAG" "$ORG/$SERVICE:latest"
        fi
    done <<< "$SERVICES"
fi
