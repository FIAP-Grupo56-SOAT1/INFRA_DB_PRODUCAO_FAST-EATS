#para criar a par de chave abrir o terminar e executar:
# ssh-keygen -f aws-key

#-----------------CRIANDO UMA VM COM MONGODB E VPC FASTEATS-----------------
#data "terraform_remote_state" "vpc_fasteats" {
#  backend = "s3"
#  config = {
#    bucket = "bucket-fiap56-to-remote-state"
#    key    = "aws-vpc-network-fiap56/terraform.tfstate"
#    region = "us-east-1"
#  }
#}
#
#
#resource "aws_instance" "vm" {
#  ami                         = "ami-07d9b9ddc6cd8dd30"
#  instance_type               = "t2.micro"
#  subnet_id                   = data.terraform_remote_state.vpc_fasteats.outputs.subnet_publica_id
#  vpc_security_group_ids      = [
#    data.terraform_remote_state.vpc_fasteats.outputs.security_group_id,
#    aws_security_group.ec2_mongodb_sg.id]
#  associate_public_ip_address = true
#  user_data                   = file("./scripts/criar_mongodb.sh")
#
#
#  tags = {
#    Name = "vm-mongodb"
#  }
#}

#-----------------CRIANDO UMA VM COM MONGODB E VPC DEFALT-----------------
##### Creating a VPC #####
# Provide a reference to your default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Provide references to your default subnets
resource "aws_default_subnet" "default_subnet_a" {
  # Use your own region here but reference to subnet 1a
  availability_zone = "us-east-1a"
}

resource "aws_instance" "vm_mongodb" {
  ami                         = "ami-07d9b9ddc6cd8dd30"
  instance_type               = "t2.micro"
  subnet_id                   = aws_default_subnet.default_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_mongodb_sg.id]
  associate_public_ip_address = true
  #user_data                   = file("./scripts/criar_mongodb.sh")
  user_data = <<-EOF
              #!/bin/bash
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
#sudo docker run -d --name mongodb -p 27017:27017 mongo
sudo docker run -d --name mongodb -p 27017:27017 \
      --restart unless-stopped \
      -e MONGO_INITDB_ROOT_USERNAME=fiap56 \
      -e MONGO_INITDB_ROOT_PASSWORD=fiapsoat1grupo56 \
      mongo
              EOF

  tags = {
    Name = "vm_mongodb"
  }
}

#-------------------------------------------------------------------------

# Security Group for EC2 Instance
resource "aws_security_group" "ec2_mongodb_sg" {
  name        = "ec2_mongo_sg"
  description = "Security group for EC2 MongoDB instance"
  #vpc_id      = data.terraform_remote_state.vpc_fasteats.outputs.vpc_id
  vpc_id      = aws_default_vpc.default_vpc.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8082
    to_port   = 8082
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# precisa permissao root se tiver no wsl basta sudo su
#depois de criar a VM usuário ubunto se usou imagem ubunto @ e IP
#ssh -i aws-key ubuntu@54.88.11.188
#yes
#enter

#entrar cd /
#cd ls
# para destruir
#exit para sair da maquina
# terraform destroy

#para ver os logs do script do user-data
# cd var/log
#tail -f cloud-init-output.log
#vejo em tempo real meu scrip rodando


