terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

# # Include S3 bucket configuration
# module "s3_bucket" {
#   source = "./s3_bucket"
# }

module "network" {
  source             = "./network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr

}

# # Include EC2 instance configuration
# module "ec2_instance" {
#   source = "./ec2_instance"
# }
