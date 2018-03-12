FROM golang:1.10-alpine as builder

RUN apk add --no-cache make git gcc

COPY . /go/src/github.com/dgraph-io/dgraph
WORKDIR /go/src/github.com/dgraph-io/dgraph

RUN make deps && rm -r /go/src/github.com/dgraph-io/dgraph

CMD ["make", "build"]
