FROM node:10.22.1-alpine3.10

ARG BRANCH=master

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

RUN git clone https://github.com/ethereum-optimism/integration-tests /integration-tests \
    && cd /integration-tests \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

WORKDIR /integration-tests

ENTRYPOINT [ "bash", "./exec/wait_for_dependencies.sh", "yarn", "run", "ci" ]
