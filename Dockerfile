FROM consul:0.7.1

ENV JSONCONSUL_VERSION=v0.4.0
ENV JSONCONSUL_NAME=jsonconsul_${JSONCONSUL_VERSION}_linux_amd64

WORKDIR /work

RUN apk add --no-cache openssl jq \
  && wget https://github.com/vsco/jsonconsul/releases/download/${JSONCONSUL_VERSION}/${JSONCONSUL_NAME}.tar.gz \
  && tar xzf $JSONCONSUL_NAME.tar.gz \
  && mv $JSONCONSUL_NAME/jsonconsul /usr/local/bin \
  && apk del openssl \
  && rm -Rf /work

WORKDIR /

COPY load.sh /usr/local/bin/load
COPY snapshot.sh /usr/local/bin/snapshot

VOLUME /consul/snapshots

ENV CONSUL_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh
ENV SNAPSHOT=/consul/snapshots/state.snap

ENTRYPOINT ["/usr/local/bin/load"]
CMD ["agent", "-dev", "-client", "0.0.0.0"]
