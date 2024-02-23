output "ip_ec2_dynamodb" {
  description = "ip_vpc_dynamodb"
  value       = aws_instance.vm.public_ip
}

