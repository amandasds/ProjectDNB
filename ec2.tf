/*resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  content           = "private_key"
  filename          = "${var.namespace}-key.pem"

}
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "${var.namespace}-key"
  create_private_key = true
}

// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  ami                         = var.aws_ami
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.allow_ssh_pub.id]

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLI"
  }
  depends_on = [
    aws_cloudtrail.checaec2
  ]
}
// Configure the EC2 instance in a private subnet
resource "aws_instance" "ec2_private" {
  ami                         = var.aws_ami
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [aws_security_group.allow_ssh_priv.id]
  depends_on = [
    aws_cloudtrail.checaec2
  ]
  tags = {
    "Name" = "${var.namespace}-EC2-PRIVATE"
  }

}
*/

