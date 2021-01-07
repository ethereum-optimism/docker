FROM node:10.23-buster

RUN apt-get update \
    && apt-get install -y bash git build-essential curl jq python3 \
    && mv /usr/bin/python /usr/bin/python2 \
    && ln -s $(which python3) /usr/bin/python

# until deployment fix gets merged, hardcoded build-testhelpers
# ARG REMOTE=https://github.com/Synthetixio/synthetix.git
ARG REMOTE=https://github.com/tynes/synthetix.git
ARG BRANCH=master

RUN git clone $REMOTE /opt/synthetix \
    && cd /opt/synthetix \
    && git checkout build-testhelpers \
    && npm install

WORKDIR /opt
COPY wait-for-node.sh /opt/wait-for-node.sh
COPY entrypoint.sh /opt/entrypoint.sh

ENV SERVER_PORT=8081

ENTRYPOINT ["/opt/wait-for-node.sh", "/opt/entrypoint.sh", "/opt/synthetix"]
