#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "* Adjusting the /etc/hosts file ..."

tee /etc/hosts <<'EOF'
127.0.0.1 localhost

192.168.99.100 docker1.home.lab docker1
192.168.99.101 docker2.home.lab docker2
192.168.99.102 docker3.home.lab docker3

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
