#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "$@" | bin/ssh-postgres.sh docker-compose exec -T postgres psql -U debezium
