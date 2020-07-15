FROM golang:alpine AS builder
LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"
LABEL maintainer="Anthony D. de Guia <tonydeguia@moe.ph>"

ENV PKGVER   1.0.0

# Busybox wget needs TLS support, curl is less painful to get working
RUN apk add --no-cache ca-certificates curl && \
    mkdir /go || true && \
    cd /go && \
    mkdir -p src/github.com/syncthing && \
    export SRCDIR=$PWD && \
    cd src/github.com/syncthing && \
    curl -L https://github.com/syncthing/syncthing/releases/download/v$PKGVER/syncthing-source-v${PKGVER}.tar.gz | tar xzf - && \
    cd syncthing && \
    export GOPATH="$SRCDIR" GOROOT_FINAL="/usr/bin" && \
    go run build.go -no-upgrade -version v${PKGVER} build strelaysrv

#Building thin container
FROM alpine

RUN apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/syncthing/syncthing/strelaysrv /usr/bin/strelaysrv

# Run unprivileged out of /data, and set custom user ID for security purposes.
RUN adduser -D -h /data -u 10008 syncrelay
USER syncrelay
WORKDIR /data

## Set some strelaysrv command arguments for information and rate limiting purposes.
ENTRYPOINT ["/usr/bin/strelaysrv"]
CMD ["-keys=/data","-provided-by=moe.ph","-global-rate=1111111"]
