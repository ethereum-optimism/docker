FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git build-essential

ARG REMOTE=https://github.com/ethereum-optimism/data-transport-layer
ARG BRANCH=master
ARG OUTDIR=/opt/data-transport-layer

RUN git clone $REMOTE $OUTDIR \
    && cd $OUTDIR \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:10.23-buster
RUN apt-get update \
    && apt-get install -y bash curl jq

COPY --from=build $OUTDIR $OUTDIR
COPY wait-for-l1.sh $OUTDIR/wait-for-l1.sh

WORKDIR $OUTDIR

ENTRYPOINT ["./wait-for-l1.sh", "yarn", "start"]
