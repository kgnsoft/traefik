#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

sudo yum update -y

#sudo yum install ansible  -y
sudo amazon-linux-extras install docker -y

#start the servie
sudo systemctl start docker

sleep 30;
