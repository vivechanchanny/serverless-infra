#!/bin/bash

echo "set -o vi" >> ~/.bashrc
sudo bash -c 'echo set -o vi >> ~root/.bashrc'

sudo apt update && sudo apt -y upgrade 
sudo apt-get install tree -y
sudo apt-get install unzip -y
