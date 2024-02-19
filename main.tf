terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }

  backend "s3" {
    bucket = "bucket-fiap56-to-remote-state"
    key    = "aws-infra-docdb-producao-fiap56/terraform.tfstate"
    region = "us-east-1"
  }
}



provider "aws" {
  region = var.region
  default_tags {
    tags = {
      owner      = var.owner
      managed-by = var.managedby
    }
  }
}

##### Creating a VPC #####
# Provide a reference to your default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Provide references to your default subnets
resource "aws_default_subnet" "default_subnet_a" {
  # Use your own region here but reference to subnet 1a
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  # Use your own region here but reference to subnet 1b
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  # Use your own region here but reference to subnet 1b
  availability_zone = "us-east-1c"
}


resource "aws_docdb_subnet_group" "produacao_docdb_subnet_group" {
  name       = "produacao-docdb-subnet-group"
  subnet_ids = [ # Referencing the default subnets
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]

  tags = {
    Name = "produacao-docdb-subnet-group"
  }
}

resource "aws_docdb_cluster" "produacao_docdb_cluster" {
  cluster_identifier      = "produacao-docdb-cluster"
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.docdb_credentials.secret_string)["username"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.docdb_credentials.secret_string)["password"]
  backup_retention_period = 0
  #preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.produacao_docdb_subnet_group.name

  #enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  apply_immediately = true

  engine      = "docdb"
  engine_version = "3.6.0"
  storage_encrypted = false

  vpc_security_group_ids = [aws_security_group.docdb_producao_sg.id]

  tags = {
    Name = "producao-docdb-cluster"
  }
}

# Export the DocumentDB endpoint so it can be used in other resources
output "endpoint" {
  value = aws_docdb_cluster.produacao_docdb_cluster.endpoint
}

#create a security group for RDS Database Instance
resource "aws_security_group" "docdb_producao_sg" {
  name = "docdb_producao_sg"
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_secretsmanager_secret" "docdb" {
  name = "prod/soat1grupo56/Docdb"
}

data "aws_secretsmanager_secret_version" "docdb_credentials" {
  secret_id = data.aws_secretsmanager_secret.docdb.id
}
