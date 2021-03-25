#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck disable=SC2029
ssh root@"$(terraform output -raw debezium_address)" "$@"
