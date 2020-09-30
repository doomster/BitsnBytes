#!/bin/bash 

echo "Post deployment script for debian 10"
echo
echo
echo "Setting up hostname..."
echo
read "give me hostname" hostname
sudo hostnamectl set-hostname $hostname
echo
echo "Getting latest updates"
sudo apt-get update >/dev/null
sudo apt-get upgrade -y >/dev/null
echo
echo "Installing essential software"
sudo apt-get install build-essential git apache ufw -y >/dev/null
echo 
echo "Setting up firewall (allow ssh,https,http)"
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo "y" | sudo ufw enable 
echo
echo "Installing php.."
sudo apt-get install php7.3 -y  >/dev/null

sudo a2enmod rewrite
sudo systemctl restart apache2
sudo echo "ok" > /var/www/html/index.html

echo "installing mysql"
sudo apt-get install mariadb-server -y >/dev/null
sudo mysql_secure_installation

echo "installing certbot"
sudo apt-get install certbot python-certbot-apache -y >/dev/null
