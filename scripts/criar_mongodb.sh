#! /bin/bash

# Instalação do MongoDB
#sudo apt-get update
#sudo apt-get install gnupg curl
#sudo curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
#sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
# --dearmor
#sudo echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
#sudo apt-get update
#sudo apt-get install -y mongodb-org
#sudo systemctl start mongod
#sudo systemctl enable mongodb


# Instalação do Java
#sudo add-apt-repository ppa:openjdk-r/ppa -y
#sudo apt-get update
#sudo apt-get install openjdk-8-jdk -y
#sudo wget https://arterp.com.br/apps/emissor-api.jar
#sudo java -jar emissor-api.jar

# Instalação do Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Pull latest mongodb image
sudo docker pull mongo:latest

# Run MongoDB image as a container
sudo docker rm mongodb
sudo docker run -d --name mongodb -p 27017:27017 mongo