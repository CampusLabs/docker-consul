#!/bin/sh

$CONSUL_ENTRYPOINT "$@" &

until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:8500/v1/health/service/consul); do
  sleep 1
done

if [ -f $SNAPSHOT ]; then
  consul snapshot restore $SNAPSHOT
else
  consul snapshot save $SNAPSHOT
fi

wait $!
