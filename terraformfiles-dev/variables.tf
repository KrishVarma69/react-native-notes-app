# variables.tf

variable "region" {
  description = "The AWS region to deploy in"
  default     = "us-wast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  default     = "ami-0e1bed4f06a3b463d"
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use"
  default     = "deployer-key"
}

variable "public_key_path" {
  description = "The path to the public key file"
  default     = "~/.ssh/id_rsa.pub"
}
