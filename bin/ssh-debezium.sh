#!/bin/bash

ssh root@$(terraform output -raw debezium_address) $@
