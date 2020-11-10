#!/usr/bin/env bash


if [[ ! -e acme.json ]]; then
	touch acme.json
	chmod 600 acme.json
fi

docker network ls|grep web > /dev/null || docker network create --driver bridge web
docker network ls|grep internal > /dev/null || docker network create --driver bridge internal

docker-compose up -d