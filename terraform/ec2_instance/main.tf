# Generate key pair to access the server via ssh
resource "tls_private_key" "custom_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.custom_key.public_key_openssh
}

resource "aws_security_group" "tp_security_group" {
  description = "Security group to allow inbound SCP & outbound 8080 (Airflow) connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tp_security_group"
  }

}

resource "aws_instance" "tp_ec2_instance" {
  ami           = "ami-0deb35a8202ca99c1" # Ubuntu Focal 20.04 (LTS) AMI ID
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.tp_security_group.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "tp_ec2_instance"
  }
}
