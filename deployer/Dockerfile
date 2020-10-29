FROM node:10.22.1-alpine3.10 as build

RUN apk update \
    && apk add --no-cache bash git python alpine-sdk

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/contracts-v2 /opt/contracts-v2 \
    && cd /opt/contracts-v2 \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.22.1-alpine3.10
RUN apk update \
    && apk add --no-cache bash curl python3 jq \
    && ln -s /usr/bin/python3 /usr/bin/python

COPY --from=build /opt/contracts-v2 /opt/contracts-v2
COPY wait-for-l1.sh /opt/contracts-v2/wait-for-l1.sh

WORKDIR /opt/contracts-v2

ENV SERVER_PORT=8080

ENTRYPOINT ["./wait-for-l1.sh", "./bin/deploy.js"]
