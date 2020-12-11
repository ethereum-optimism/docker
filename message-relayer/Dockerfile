FROM node:10.23-buster as base

RUN apt-get update \
    && apt-get install -y bash curl jq

FROM base as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH=master

RUN git clone https://github.com/ethereum-optimism/optimism-ts-services /opt/optimism-ts-services \
    && cd /opt/optimism-ts-services \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM base

RUN apt-get update \
    && apt-get install -y bash curl jq

COPY --from=build /opt/optimism-ts-services /opt/optimism-ts-services
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/optimism-ts-services/exec/run.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run.js"]
