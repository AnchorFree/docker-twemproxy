FROM alpine AS build-env

ADD . /root/twemproxy

WORKDIR /root/twemproxy

RUN apk add --no-cache autoconf automake libtool g++ make && \
	autoreconf -fvi && ./configure && make

FROM alpine

# CONFIGURE APK
# https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Repository_pinning
RUN echo '@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories
RUN echo '@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN echo '@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk update
RUN apk add --upgrade apk-tools@edge-main

# CONFIGURE HEALTHCHECKS & INSTALL DEPENDENCIES
RUN apk add fcgi bats@edge-community
HEALTHCHECK --interval=30s --timeout=30s --start-period=1s --retries=3 CMD bats /bats/healthchecks.bats || exit 1

COPY --from=build-env /root/twemproxy/src/nutcracker /usr/sbin/nutcracker

CMD ["/usr/sbin/nutcracker", "-c", "/opt/nutcracker.yml"]
