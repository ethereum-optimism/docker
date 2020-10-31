FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/optimism-monorepo /opt/optimism-monorepo \
    && cd /opt/optimism-monorepo \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.23-buster

RUN apt-get update \
    && apt-get install -y bash curl

COPY --from=build /opt/optimism-monorepo /opt/optimism-monorepo
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/optimism-monorepo/packages/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run-batch-submitter.js"]
