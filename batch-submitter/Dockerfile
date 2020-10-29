FROM node:10.22.1-alpine3.10 as build

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/optimism-monorepo /opt/optimism-monorepo \
    && cd /opt/optimism-monorepo \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.22.1-alpine3.10

RUN apk update \
    && apk add --no-cache bash curl

COPY --from=build /opt/optimism-monorepo /opt/optimism-monorepo
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/optimism-monorepo/packages/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run-batch-submitter.js"]
