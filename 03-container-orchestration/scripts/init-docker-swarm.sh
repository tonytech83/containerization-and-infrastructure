#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

docker swarm init --advertise-addr 192.168.99.100 && \
docker swarm join-token worker -q > /vagrant/worker_token.txt
