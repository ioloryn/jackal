FROM golang:1.10 as buildimage

LABEL org.label-schema.version=latest
LABEL org.label-schema.vcs-url="https://github.com/ortuman/jackal.git"
LABEL org.label-schema.name="jackal"
LABEL org.label-schema.vendor="Miguel Ángel Ortuño"
LABEL maintainer="Miguel Ángel Ortuño <ortuman@protonmail.com>"

WORKDIR /jackal

RUN curl -L -s https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -o $GOPATH/bin/dep
RUN chmod +x $GOPATH/bin/dep
RUN go get -d github.com/ioloryn/jackal

RUN cd $GOPATH/src/github.com/ioloryn/jackal && dep ensure
RUN export CGO_ENABLED=0
RUN export GOOS=linux
RUN export GOARCH=amd64
RUN go build github.com/ioloryn/jackal

FROM debian:stretch-slim
COPY --from=buildimage /jackal/jackal /
ADD example.jackal.yml /etc/jackal/jackal.yml
EXPOSE 5222
CMD ["./jackal"]
