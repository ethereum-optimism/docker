FROM node:14-buster as build

RUN apt-get update \
    && apt-get install -y bash git build-essential

ARG REMOTE=https://github.com/ethereum-optimism/data-transport-layer
ARG BRANCH=master

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    $REMOTE /opt/transaction-indexer \
    && cd /opt/transaction-indexer \
    && yarn install \
    && yarn build

FROM node:14-buster
RUN apt-get update \
    && apt-get install -y bash curl jq

COPY --from=build /opt/transaction-indexer /opt/transaction-indexer
COPY wait-for-l1.sh /opt/wait-for-l1.sh

WORKDIR /opt/transaction-indexer

ENTRYPOINT ["/opt/wait-for-l1.sh", "yarn", "start"]
