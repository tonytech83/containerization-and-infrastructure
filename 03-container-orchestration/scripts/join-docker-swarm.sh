#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

docker swarm join --token "$(cat /vagrant/worker_token.txt)" 192.168.99.100:2377 || { echo "Swarm join failed"; exit 1; }
