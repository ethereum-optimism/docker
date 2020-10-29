FROM node:10.22.1-alpine3.10 as build

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/hardhat-hackathon-boilerplate.git /opt/hardhat \
    && cd /opt/hardhat \
    && git checkout $BRANCH \
    && yarn

WORKDIR /opt/hardhat
COPY start.sh /opt/hardhat/start.sh

ENTRYPOINT ["/opt/hardhat/start.sh"]
