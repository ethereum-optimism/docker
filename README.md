# docker

Repo for building, tagging and pushing Docker images

## Scripts

### `build.sh`

Build Docker images, use the `-s` flag to select a service to build.
If no `-s` flag is passed, all images will be built.

### `push.sh`

Push a docker image to a Docker Registry.

### `clean.sh`

Remove Docker images related to this repo from the machine.
