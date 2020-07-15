FROM alpine:edge
LABEL maintainer="ZeroExistence"

## Set your timezone accordingly, based on where your server is deployed.
## I manually changed the user ID of tor user, to prevent multiple containers with same user ID.
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
  echo 'Asia/Manila' > /etc/timezone && \
  apk --no-cache add tor obfs4proxy && \
  sed -i 's/^tor:x:100/tor:x:10029/g' /etc/passwd && \
  rm -rf /var/cache/apk/*

## Set my own volume path, for easier configuration management.
VOLUME ["/data"]

USER tor
CMD ["/usr/bin/tor","-f","/data/torrc"]
