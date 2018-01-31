#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-66506c1c
#
# Your subnet ID is:
#
#     subnet-849ca4cf
#
# Your security group ID is:
#
#     sg-3ee83749
#
# Your Identity is:
#
#     customer-training-swordfish
#

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "label" {
  default = "training"
}

variable "num_webs" {
  default = "2"
}

terraform {
  backend "atlas" {
    name = "dhartnell/training"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "web" {
  count                  = "${var.num_webs}"
  ami                    = "ami-66506c1c"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-849ca4cf"
  vpc_security_group_ids = ["sg-3ee83749"]

  tags {
    Identity = "customer-training-swordfish"
    Owner    = "Daniel"
    Company  = "Mozilla"
    Name     = "${var.label} ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
