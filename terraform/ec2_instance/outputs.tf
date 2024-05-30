output "public_dns" {
  description = "EC2 public dns."
  value       = aws_instance.tp_ec2_instance.public_dns
}

output "private_key" {
  description = "EC2 private key."
  value       = tls_private_key.custom_key.private_key_pem
  sensitive   = true
}

output "public_key" {
  value = tls_private_key.custom_key.public_key_openssh
}
