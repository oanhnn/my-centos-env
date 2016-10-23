#!/bin/bash
echo ">> Install Docker"

# copy repo file
if [[ ! -f /etc/yum.repos.d/docker.repo ]]
then
    sudo cp -f /vagrant/etc/yum.repos.d/docker.repo /etc/yum.repos.d/
    sudo yum -y update
fi

# Install Docker
sudo yum install -y docker-engine

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add UNIX group for run Docker
sudo groupadd docker
sudo usermod -aG docker `whoami`
