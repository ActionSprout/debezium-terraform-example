#!/bin/bash

echo $@ | bin/ssh-postgres.sh docker-compose exec -T postgres psql -U debezium
