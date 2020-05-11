FROM golang:1.14-alpine3.11 AS builder

ENV CGO_ENABLED=0
RUN apk add --no-cache ca-certificates
COPY . /go/src/github.com/ezodude/docker-stack-poc
WORKDIR /go/src/github.com/ezodude/docker-stack-poc
RUN mkdir -p bin
RUN go build -o bin/backend cmd/api/*.go

FROM alpine:3.11

RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/ezodude/docker-stack-poc/bin/* /bin/

USER 65534
CMD [ "sh", "-c", "/bin/backend" ]