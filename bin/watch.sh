#!/bin/bash


bin/ssh-debezium.sh docker-compose exec -T kafka /docker-entrypoint.sh watch-topic debezium.public.people
