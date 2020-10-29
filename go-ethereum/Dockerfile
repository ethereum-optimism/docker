FROM golang:1.14-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ARG BRANCH=master

RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    https://github.com/ethereum-optimism/go-ethereum /go-ethereum \
    && cd /go-ethereum \
    && make geth

FROM alpine:latest

RUN apk add --no-cache ca-certificates curl bash jq
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 8547

COPY wait-for-l1.sh /bin/wait-for-l1.sh

ENTRYPOINT ["/bin/wait-for-l1.sh", "geth", "--verbosity=6"]
