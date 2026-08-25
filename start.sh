#!/bin/bash
source vars
#docker network create --subnet ${DOCKERNETWORK} --gateway ${DOCKERGATEWAY} --ipv6 mailnet
docker network create mailnet
docker compose -f docker-compose.postgresql.yml up --build -d
