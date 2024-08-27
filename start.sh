#!/bin/bash
source vars
docker compose -f docker-compose.postgresql.yml up --build -d

