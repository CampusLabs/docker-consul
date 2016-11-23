FROM consul:0.7.1

ENV JSONCONSUL_VERSION=v0.4.0
ENV JSONCONSUL_NAME=jsonconsul_${JSONCONSUL_VERSION}_linux_amd64

WORKDIR /work

RUN apk add --no-cache openssl jq \
  && wget https://github.com/vsco/jsonconsul/releases/download/${JSONCONSUL_VERSION}/${JSONCONSUL_NAME}.tar.gz \
  && tar xzf $JSONCONSUL_NAME.tar.gz \
  && mv $JSONCONSUL_NAME/jsonconsul /usr/local/bin \
  && mkdir -p /consul/kv \
  && chown -R consul:consul /consul/kv \
  && apk del openssl \
  && rm -Rf /work

WORKDIR /

COPY load.sh /usr/local/bin/load
COPY backup.sh /usr/local/bin/backup
COPY kv.json /consul/backup/kv.json

VOLUME /consul/backup

ENV CONSUL_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh
ENV JSONCONSUL=/usr/local/bin/jsonconsul
ENV KV_SOURCE=/consul/backup/kv.json

ENTRYPOINT ["/usr/local/bin/load"]
CMD ["agent", "-dev", "-client", "0.0.0.0"]
