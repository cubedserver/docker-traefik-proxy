#!/usr/bin/env bash

docker rm -f traefik-proxy

docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $PWD/acme.json:/acme.json \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  -l traefik.frontend.rule=Host:monitor.example.com \
  -l traefik.port=8080 \
  --network traefik-proxy \
  --name traefik-proxy \
  traefik:1.5.3-alpine --docker