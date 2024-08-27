#!/bin/bash
source vars
docker compose -f docker-compose.yml up -d --build
