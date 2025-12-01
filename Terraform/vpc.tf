variable "my_cidr_block" {
  default = "10.0.0.0/16"
}

variable "my_env" {}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.my_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-${var.my_env}"
  }
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
