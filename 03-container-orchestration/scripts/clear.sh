#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "Remove docker swarm join token"
rm -f /vagrant/worker_token.txt