#! /bin/bash

sudo apt-get update
sudo apt-get install gnupg curl
sudo curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
 --dearmor
sudo echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongodb


#sudo add-apt-repository ppa:openjdk-r/ppa -y
#sudo apt-get update
#sudo apt-get install openjdk-8-jdk -y
#sudo wget https://arterp.com.br/apps/emissor-api.jar
#sudo java -jar emissor-api.jar
