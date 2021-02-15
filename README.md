# docker

Repo for building, tagging and pushing Docker images

## Scripts

### `build.sh`

Build Docker images, use the `-s` flag to select a service to build.
If no `-s` flag is passed, all images will be built. Each service that
can be built is represented by a directory in this repository.

### `clean.sh`

Remove Docker images related to this repo from the machine.

## Developing

Add a directory to this repository that contains a `Dockerfile` and
any files that are necessary to build the docker image. This repository
is opinionated when it comes to building docker images in a position
independent way, meaning that the `Dockerfile`s all build by cloning
the code from a remote git repository.
