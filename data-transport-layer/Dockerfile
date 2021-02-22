FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git build-essential

ARG REMOTE=https://github.com/ethereum-optimism/data-transport-layer
ARG BRANCH=master

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    $REMOTE /opt/data-transport-layer \
    && cd /opt/data-transport-layer \
    && yarn install \
    && yarn build

FROM node:10.23-buster
RUN apt-get update \
    && apt-get install -y bash curl jq

COPY --from=build /opt/data-transport-layer /opt/data-transport-layer
COPY wait-for-l1.sh /opt/wait-for-l1.sh

WORKDIR /opt/data-transport-layer

ENTRYPOINT ["/opt/wait-for-l1.sh", "yarn", "start"]
