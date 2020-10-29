FROM node:10.22.1-alpine3.10

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk jq

ARG BRANCH=master

RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    https://github.com/ethereum-optimism/integration-tests /integration-tests \
    && cd /integration-tests \
    && yarn install \
    && yarn build

COPY wait-for-l1-and-l2-and-contract-deployment.sh /integration-tests/wait.sh
WORKDIR /integration-tests

ENTRYPOINT ["/integration-tests/wait.sh", "yarn", "run", "ci"]
