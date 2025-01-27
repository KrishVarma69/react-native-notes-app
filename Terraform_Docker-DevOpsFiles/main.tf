terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Define variables
variable "region" {
  default = "us-west-2"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami" {
  default = "ami-0c55b159cbfafe1f0"  # Replace with a valid Ubuntu AMI ID for your region
}
variable "key_name" {}
variable "private_key_path" {}

# Security group
resource "aws_security_group" "allow_ssh_http" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "react-native-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "react-native-subnet"
  }
}

# Network interface
resource "aws_network_interface" "main" {
  subnet_id = aws_subnet.main.id

  tags = {
    Name = "react-native-nic"
  }
}

# EC2 instance
resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }
  security_groups        = [aws_security_group.allow_ssh_http.name]
  associate_public_ip_address = true

  tags = {
    Name = "ReactNativeNotesApp"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
  EOF
}

output "instance_ip" {
  value = aws_instance.app.public_ip
}


# Below are the commands to execute the terraform file
    # terraform init
    # terraform plan -var-file="terraform.tfvars"
    # terraform apply -var-file="terraform.tfvars"
