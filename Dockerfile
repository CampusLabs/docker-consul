FROM consul:0.7.1

RUN apk add --no-cache nodejs \
  && npm install -g consul-to-json \
  && mkdir -p /consul/kv \
  && chown -R consul:consul /consul/kv

COPY load.sh /usr/local/bin/
COPY kv.json /consul/backup/kv.json

VOLUME /consul/backup
ENV KV_SOURCE=/consul/backup/kv.json

ENTRYPOINT ["/usr/local/bin/load.sh"]
CMD ["agent", "-dev", "-client", "0.0.0.0"]
