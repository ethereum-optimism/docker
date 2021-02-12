ARG BRANCH=master
ARG REMOTE=https://github.com/ethereum-optimism/go-ethereum

FROM golang:1.14-buster as builder

RUN apt-get update \
  && apt-get install -y build-essential

ARG BRANCH
ARG REMOTE

RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    $REMOTE /go-ethereum \
    && cd /go-ethereum \
    && make geth

FROM golang:1.14-buster

ARG BRANCH
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN apt-get update \
    && apt-get install -y bash curl jq ca-certificates

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 8547

COPY wait-for-l1.sh /bin/wait-for-l1.sh

ENTRYPOINT ["/bin/wait-for-l1.sh", "geth", "--verbosity=6"]
