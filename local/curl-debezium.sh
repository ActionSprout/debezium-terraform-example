#!/bin/bash

path=$1
shift

curl -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/$path "$@"

