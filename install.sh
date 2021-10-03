#!/bin/bash

: ${DOCKER_NETWORKS:='web internal'}
: ${DOCKER_COMPOSE_FILE:='docker-compose.yml'}
: ${ADDITIONAL_APPS:='adminer mysql phpmyadmin portainer postgres redis whoami wordpress'}

function setup_log() {
  echo -e $1
}

for NETWORK_NAME in $DOCKER_NETWORKS; do
    setup_log "⚡ Creating Docker network ${NETWORK_NAME}"
    docker network ls|grep $NETWORK_NAME > /dev/null || docker network create $NETWORK_NAME
done

if [[ ! -e acme.json ]]; then
	touch acme.json
	chmod 600 acme.json
fi

docker-compose -f $DOCKER_COMPOSE_FILE up -d

if [[ ! -z $ADDITIONAL_APPS ]]; then
    for APP in $ADDITIONAL_APPS; do
        if [ -d templates/${APP} ]; then

            setup_log "---> ⚡ Starting ${APP} container"
            docker-compose -f templates/${APP}/docker-compose.yml up -d
        else
            setup_log "---> ❌ App ${APP} files not found. Skipping..."
        fi
    done    
fi