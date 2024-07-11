#!/bin/bash

sudo apt update
sudo apt install -y python3-pip
sudo rm -r /var/www/html
sudo ln -s $(pwd) /var/www/html
sudo a2enmod cgid
sudo service apache2 start
pip install pytest
