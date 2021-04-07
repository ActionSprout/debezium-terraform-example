#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

NAME=etl-watcher
docker stop $NAME || true #; docker system prune -f; true

docker run --name $NAME --rm --network as_default --link as_etl-zookeeper_1:zookeeper -e ZOOKEEPER_CONNECT=zookeeper -e KAFKA_BROKER=as_etl-kafka_1:9092 debezium/kafka watch-topic -a ${1:-postgres-people.public.people}


