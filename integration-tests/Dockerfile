FROM node:14-buster

RUN apt-get update \
    && apt-get install -y bash git python build-essential jq

ARG BRANCH=master
ARG REMOTE=https://github.com/ethereum-optimism/integration-tests
LABEL io.optimism.repo.git.remote=$REMOTE

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    $REMOTE /integration-tests \
    && cd /integration-tests \
    && yarn install \
    && yarn build

COPY wait-for-l1-and-l2-and-contract-deployment.sh /opt/wait.sh
WORKDIR /integration-tests

ENTRYPOINT ["/opt/wait.sh", "yarn", "run", "ci"]
