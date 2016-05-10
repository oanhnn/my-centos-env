#!/usr/bin/bash
echo ">> Install Redis"
sudo yum install --enablerepo=remi -y -q redis

# ensure it is running
sudo systemctl start redis

# set to auto start
sudo systemctl enable redis

# Get port argument, default: 6379
if [ -z $1 ]
then
  REDIS_PORT=6379;
else
  REDIS_PORT=$1;
fi

echo ">> Configure Redis"
sudo sed -i "s/^daemonize no$/daemonize yes/" /etc/redis.conf && \
sudo sed -i "s/^bind 127.0.0.1$/bind 0.0.0.0/" /etc/redis.conf && \
sudo sed -i "/^port\s*/cport ${REDIS_PORT}" /etc/redis.conf

sudo systemctl restart redis
