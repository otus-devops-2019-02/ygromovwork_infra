#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install
#puma -d

sudo cp -a /home/ygromov/puma.service /etc/systemd/system/puma.service

/bin/systemctl enable puma

ps aux | grep puma


