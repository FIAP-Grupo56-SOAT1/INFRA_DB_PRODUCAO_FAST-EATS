output "ip_ec2_mongodb" {
  description = "ip_ec2_mongodb"
  value       = aws_instance.vm_mongodb.public_ip
}

