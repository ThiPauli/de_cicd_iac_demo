variable "key_name" {
  description = "The name of the EC2 key pair."
  type        = string
  default     = "tp_ec2_key"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "m4.2xlarge"
}

# From resource defined in Network Module
variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

# From resource defined in Network Module
variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
}
