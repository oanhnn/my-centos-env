#!/usr/bin/bash
echo ">> Install NodeJS 4.x"
curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
sudo yum install -y nodejs
npm config set bin-links false

echo ">> Install Gulp"
npm install --global --bin-links gulp-cli

echo ">> Install Yarn"
npm install --global --bin-links yarn

