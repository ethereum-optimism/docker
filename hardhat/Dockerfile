FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/hardhat-hackathon-boilerplate.git /opt/hardhat \
    && cd /opt/hardhat \
    && git checkout $BRANCH \
    && yarn

WORKDIR /opt/hardhat
COPY start.sh /opt/hardhat/start.sh

ENTRYPOINT ["/opt/hardhat/start.sh"]
