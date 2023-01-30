variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
        default = "us-east-1"
}

variable "namespace" {
  type = string
  default = "testesg"
}
variable "aws_ami" {
    type = string
    default = "ami-0aa7d40eeae50c9a9"
}

variable "bucket_name" {
    default = "projetodnb"
}