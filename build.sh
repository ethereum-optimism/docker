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
REMOTE=""

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
    -r|--remote)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        REMOTE="$2"
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

TAG=$(echo $TAG | sed 's/\//_/g')

function build() {
    cmd="docker build"
    cmd="$cmd --label io.optimism.repo=docker"
    cmd="$cmd --label io.optimism.repo.git.branch=$GIT_BRANCH"
    cmd="$cmd --build-arg BRANCH=$GIT_BRANCH"
    if [ ! -z "$REMOTE" ]; then
        cmd="$cmd --build-arg REMOTE=$REMOTE"
    fi
    cmd="$cmd -f $DIR/$SERVICE/Dockerfile"
    cmd="$cmd -t $ORG/$SERVICE:$TAG $DIR/$SERVICE"

    $cmd
}

if [ -n "$SERVICE" ]; then
    build
    if [ $TAG == 'master' ]; then
        docker tag $ORG/$SERVICE:$TAG $ORG/$SERVICE:latest
    fi
else
    SERVICES=$(cd $DIR; echo */ | tr -d '/' | tr ' ' '\n')
    while read -r SERVICE; do
        # only default remotes are supported when building all
        REMOTE=
        build
        if [ "$TAG" == 'master' ]; then
            docker tag "$ORG/$SERVICE:$TAG" "$ORG/$SERVICE:latest"
        fi
    done <<< "$SERVICES"
fi
