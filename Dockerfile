FROM alpine:3.5

ENV TWEMPROXY_VERION 0.4.1
ENV TWEMPROXY_DOWNLOAD_URL https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz
ENV CFLAGS -O3 -fno-strict-aliasing

# install build dependencies
RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		linux-headers \
		make \
		autoconf \
		automake \
		libtool \
		musl-dev \
		ca-certificates \
		openssl \
		tar \
	&& update-ca-certificates

# download source & unpack
RUN wget -O twemproxy.tar.gz "$TWEMPROXY_DOWNLOAD_URL" \
	&& mkdir -p /usr/src/twemproxy \
	&& tar -xzf twemproxy.tar.gz -C /usr/src/twemproxy --strip-components=1 \
	&& rm twemproxy.tar.gz

# configure twemproxy
RUN cd /usr/src/twemproxy \
	&& autoreconf -fvi \
	&& ./configure

# build twemproxy
RUN make -C /usr/src/twemproxy \
	&& make -C /usr/src/twemproxy install

# cleanup
RUN rm -r /usr/src/twemproxy \
	&&  apk del .build-deps

RUN mkdir /etc/twemproxy
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 6379
