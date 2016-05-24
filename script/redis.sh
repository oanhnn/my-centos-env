#!/usr/bin/bash
echo ">> Install Redis"
sudo yum install --enablerepo=remi -y -q redis >/dev/null 2>&1

# ensure it is running
sudo systemctl start redis

# set to auto start
sudo systemctl enable redis

echo ">> Configure Redis"
sudo sed -i "s/^daemonize no$/daemonize yes/" /etc/redis.conf
[[ ! -z $cf_redis_port ]] && sudo sed -i "s/^port\s.*$/port $cf_redis_port/" /etc/redis.conf

# enable remote access
if [[ $cf_redis_remote_access == true ]]
then
  echo ">> Enable access Redis from remote"
  sudo sed -i "s/^bind 127.0.0.1$/bind 0.0.0.0/" /etc/redis.conf
fi

sudo systemctl restart redis
