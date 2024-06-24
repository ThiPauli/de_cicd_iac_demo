resource "aws_s3_bucket" "tp_bucket" {
  bucket        = var.tp_bucket_name
  force_destroy = true
}
