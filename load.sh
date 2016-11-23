#!/bin/sh

$CONSUL_ENTRYPOINT "$@" &

until $(curl --output /dev/null --silent --fail http://127.0.0.1:8500/v1/status/leader); do
  sleep 1
done

$JSONCONSUL import $KV_SOURCE
wait $!
