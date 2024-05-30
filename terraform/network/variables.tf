variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable "public_subnet_availability_zone" {
  description = "The availability zone for the public subnet."
  type        = string
}
