#!/bin/bash
set -e

sudo setenforce 0
sudo yum install nginx -y
sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf
sudo systemctl start nginx
sudo systemctl enable nginx
