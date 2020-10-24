FROM golang:1.14-alpine as builder

ARG BRANCH=master

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/ethereum-optimism/go-ethereum /go-ethereum \
    && cd /go-ethereum \
    && git checkout $BRANCH \
    && make geth

FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 8547 30303 30303/udp

COPY --from=builder /go-ethereum/docker/entrypoint.sh /bin
COPY --from=builder /go-ethereum/docker/state_dump_entrypoint.sh /bin
RUN chmod +x /bin/entrypoint.sh \
    && chmod +x /bin/state_dump_entrypoint.sh

ENTRYPOINT ["sh", "/bin/entrypoint.sh"]
