#!/bin/bash

ssh root@$(terraform output -raw postgres_address) $@
