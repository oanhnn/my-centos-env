#!/usr/bin/bash
echo ">> Install NodeJS 4.x"
curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
sudo yum install -y -q nodejs
npm config set bin-links false

echo ">> Install Gulp"
npm install --global gulp-cli --bin-links