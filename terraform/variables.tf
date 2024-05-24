variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  default     = "10.0.1.0/24"
}
