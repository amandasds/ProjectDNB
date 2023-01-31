
resource "random_pet" "lambda_bucket_name" {
  prefix = "sg-terraform-demo"
  length = 4
}
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id  
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_s3_object" "zip_the_python_code" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-python.zip"
  source = data.archive_file.zip_the_python_code.output_path

  etag = filemd5(data.archive_file.zip_the_python_code.output_path)
}
