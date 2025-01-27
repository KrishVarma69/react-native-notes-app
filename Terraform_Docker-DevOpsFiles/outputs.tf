# outputs.tf

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}
