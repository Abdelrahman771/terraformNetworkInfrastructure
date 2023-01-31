resource "aws_s3_bucket" "b" {
  bucket = "mybucket712463781246378"
    lifecycle {
      prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "mybucket712463781246378"
    key = "dev/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform_locks"
    encrypt = true
  }
}