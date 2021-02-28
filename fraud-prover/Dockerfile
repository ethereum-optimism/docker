ARG BRANCH=master
ARG REMOTE=https://github.com/ethereum-optimism/optimism-ts-services

FROM node:14-buster as base

RUN apt-get update \
    && apt-get install -y bash curl jq

FROM base as build

RUN apt-get update \
    && apt-get install -y git python build-essential

ARG BRANCH
ARG REMOTE

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone $REMOTE /opt/optimism-ts-services \
    && cd /opt/optimism-ts-services \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM base
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

COPY --from=build /opt/optimism-ts-services /opt/optimism-ts-services
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/optimism-ts-services/exec/run-fraud-prover.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run-fraud-prover.js"]
