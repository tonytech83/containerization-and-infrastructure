#!/bin/bash

export DEBIAN_FRONTEND=noninteractiv

docker swarm join --token $(cat /vagrant/worker_token.txt) 192.168.99.100:2377
