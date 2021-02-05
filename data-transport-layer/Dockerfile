FROM node:10.23-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential libusb-1.0

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
    && apt-get install -y bash curl jq python3 libusb-1.0 \
    && mv /usr/bin/python /usr/bin/python2 \
    && ln -s $(which python3) /usr/bin/python

COPY --from=build $OUTDIR $OUTDIR
COPY wait-for-l1.sh $OUTDIR/wait-for-l1.sh

WORKDIR $OUTDIR

ENTRYPOINT ["./wait-for-l1.sh", "yarn", "start"]
