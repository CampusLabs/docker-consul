#!/bin/sh

CONSUL_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh
CONSUL_TO_JSON=/usr/bin/consul-to-json

$CONSUL_ENTRYPOINT "$@" &

until $(curl --output /dev/null --silent --fail http://127.0.0.1:8500/v1/status/leader); do
  sleep 1
done

$CONSUL_TO_JSON restore $KV_SOURCE
wait $!
