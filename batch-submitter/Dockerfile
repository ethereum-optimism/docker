ARG BRANCH=master
ARG REMOTE=https://github.com/ethereum-optimism/batch-submitter

FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential jq

ARG BRANCH
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN git clone $REMOTE /opt/batch-submitter \
    && cd /opt/batch-submitter \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.23-buster
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN apt-get update \
    && apt-get install -y bash curl

COPY --from=build /opt/batch-submitter /opt/batch-submitter
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run-batch-submitter.js"]
