#!/bin/bash

COMPOSE_FILE="../../docker-compose.yml:./docker-compose.yml" docker-compose "$@"
