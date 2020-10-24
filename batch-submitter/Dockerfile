FROM node:10.22.1-alpine3.10 as build

ARG TAG=master

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

RUN git clone https://github.com/ethereum-optimism/optimism-monorepo /optimism-monorepo \
    && cd /optimism-monorepo \
    && git checkout $TAG \
    && yarn install \
    && yarn build \
    && cd /optimism-monorepo/packages/batch-submitter

FROM node:10.22.1-alpine3.10

COPY --from=build /optimism-monorepo /optimism-monorepo
RUN ln -s /optimism-monorepo/packages/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["node", "/usr/local/bin/run-batch-submitter.js"]
