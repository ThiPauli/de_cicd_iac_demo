output "aws_region" {
  description = "Region set for AWS"
  value       = var.aws_region
}

output "public_dns" {
  value = module.ec2_instance.public_dns
}

output "private_key" {
  value     = module.ec2_instance.private_key
  sensitive = true
}

output "public_key" {
  value = module.ec2_instance.public_key
}
