#!/bin/bash

./curl-debezium.sh connectors -X POST -d @people-connector.json
./curl-debezium.sh connectors -X POST -d @people-sink.json
