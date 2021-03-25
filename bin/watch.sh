#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

bin/ssh-debezium.sh docker-compose exec -T kafka /docker-entrypoint.sh watch-topic debezium.public.people |\
  tee >(grep --line-buffered -v '{' >&2) |\
  grep --line-buffered '{' |\
  jq .payload
