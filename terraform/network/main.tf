resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main_vpc_tp"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_tp"
  }

}

# output "vpc_id" {
#   value = aws_vpc.main.id
# }

# output "public_subnet_id" {
#   value = aws_subnet.public.id
# }
