#!/bin/sh

TMP_FILE=/tmp/kv_tmp.json

$JSONCONSUL export $TMP_FILE
cat $TMP_FILE | jq . > $KV_SOURCE

rm $TMP_FILE
