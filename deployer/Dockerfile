FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/contracts-v2 /opt/contracts-v2 \
    && cd /opt/contracts-v2 \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.23-buster
RUN apt-get update \
    && apt-get install -y bash curl jq python3 \
    && mv /usr/bin/python /usr/bin/python2 \
    && ln -s $(which python3) /usr/bin/python

COPY --from=build /opt/contracts-v2 /opt/contracts-v2
COPY wait-for-l1.sh /opt/contracts-v2/wait-for-l1.sh

WORKDIR /opt/contracts-v2

ENV SERVER_PORT=8080

ENTRYPOINT ["./wait-for-l1.sh", "./bin/deploy.js"]
