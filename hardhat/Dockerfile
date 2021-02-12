FROM node:10.23-buster

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH=master
ARG REMOTE=https://github.com/ethereum-optimism/hardhat
LABEL io.optimism.repo.git.remote=$REMOTE

RUN git clone $REMOTE /opt/hardhat \
    && cd /opt/hardhat \
    && git checkout $BRANCH \
    && yarn

WORKDIR /opt/hardhat
COPY start.sh /opt/hardhat/start.sh

ENTRYPOINT ["/opt/hardhat/start.sh"]
