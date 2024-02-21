##### Creating a VPC #####
# Provide a reference to your default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Provide references to your default subnets
resource "aws_default_subnet" "default_subnet_a" {
  # Use your own region here but reference to subnet 1a
  availability_zone = "us-east-1a"
}

# Subnets (Public)
resource "aws_subnet" "ec2_mongodb_subnet" {
  vpc_id                  = aws_default_vpc.default_vpc.id
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ec2_mongodb_subnet"
  }
}

resource "aws_instance" "vm" {
  ami                         = "ami-07d9b9ddc6cd8dd30"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.ec2_mongodb_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_mongodb_sg.id]
  associate_public_ip_address = true
  user_data                   = file("./scripts/criar_mongodb.sh")


  tags = {
    Name = "vm-mongodb"
  }
}

# Security Group for EC2 Instance
resource "aws_security_group" "ec2_mongodb_sg" {
  name        = "ec2_mongo_sg"
  description = "Security group for EC2 MongoDB instance"
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
