#!/bin/bash

################
# PREREQ 


echo "$(date) - PREPARING machine" >> /home/ubuntu/memtier_install.log

sudo apt-get -y update
sudo apt-get -y install build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev libssl-dev 
sudo apt-get -y install git

echo "$(date) - DOING git clone" >> /home/ubuntu/memtier_install.log

git clone https://github.com/RedisLabs/memtier_benchmark

cd memtier_benchmark

autoreconf -ivf
./configure

echo "$(date) - DOING make" >> /home/ubuntu/memtier_install.log

sudo make
sudo make install

echo "$(date) - Installation complete." >> /home/ubuntu/memtier_install.log