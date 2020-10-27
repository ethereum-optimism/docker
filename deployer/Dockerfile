FROM node:10.22.1-alpine3.10 as build

ARG TAG=master

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

RUN git clone https://github.com/ethereum-optimism/contracts-v2 /opt/contracts-v2 \
    && cd /opt/contracts-v2 \
    && git checkout $TAG \
    && yarn install \
    && yarn build

FROM node:10.22.1-alpine3.10
RUN apk update \
    && apk add --no-cache bash curl

COPY --from=build /opt/contracts-v2 /opt/contracts-v2
COPY wait-for-l1.sh /opt/contracts-v2/wait-for-l1.sh

WORKDIR /opt/contracts-v2

ENTRYPOINT ["./wait-for-l1.sh", "./bin/deploy.js"]
