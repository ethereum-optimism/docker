FROM node:10.22.1-alpine3.10 as build

ARG TAG=master

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

RUN git clone https://github.com/ethereum-optimism/optimism-monorepo /opt/optimism-monorepo \
    && cd /opt/optimism-monorepo \
    && git checkout $TAG \
    && yarn install \
    && yarn build

FROM node:10.22.1-alpine3.10

COPY --from=build /opt/optimism-monorepo /opt/optimism-monorepo
RUN ln -s /opt/optimism-monorepo/packages/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["node", "run-batch-submitter.js"]
