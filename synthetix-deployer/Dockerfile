FROM node:10.23-buster

RUN apt-get update \
    && apt-get install -y bash git build-essential curl jq python3 \
    && mv /usr/bin/python /usr/bin/python2 \
    && ln -s $(which python3) /usr/bin/python

ARG BRANCH=master

RUN git clone https://github.com/Synthetixio/synthetix.git /opt/synthetix \
    && cd /opt/synthetix \
    && git checkout $BRANCH \
    && yarn install \
    && yarn compile

WORKDIR /opt
RUN cp -rf /opt/synthetix /opt/synthetix-ovm \
    && cd /opt/synthetix \
    && node publish build \
    && cd /opt/synthetix-ovm \
    && node publish build --use-OVM

COPY wait-for-node.sh /opt/wait-for-node.sh
COPY entrypoint.sh /opt/entrypoint.sh

ENV SERVER_PORT=8081

ENTRYPOINT ["/opt/wait-for-node.sh", "/opt/entrypoint.sh", "/opt"]
