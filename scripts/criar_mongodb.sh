#! /bin/bash

#sudo add-apt-repository ppa:openjdk-r/ppa -y
#sudo apt-get update
#sudo apt-get install openjdk-8-jdk -y
#sudo wget https://arterp.com.br/apps/emissor-api.jar
#sudo java -jar emissor-api.jar

apt-get update
apt-get install gnupg curl
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
--dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl enable mongodb

