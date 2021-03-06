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
ENV MYSQL_HOST="127.0.0.1"
ENV MYSQL_PORT="16256"
ENV MYSQL_DB="jackal"
ENV MYSQL_USER="jackal"
ENV MYSQL_PASS="somepassuser"
COPY --from=buildimage /jackal/jackal /
ADD example.jackal.yml /etc/jackal/jackal.yml
ADD config-mod.sh /tmp/config-mod.sh
RUN chmod +x /tmp/config-mod.sh && /tmp/config-mod.sh
RUN cat /etc/jackal/jackal.yml
RUN printenv
EXPOSE 5222
CMD ["./jackal"]
