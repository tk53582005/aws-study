# 変数定義

variable "my_cidr_block" {
  default = "10.0.0.0/16"
}

# 環境名（stage / prod など）を受け取る
variable "my_env" {}

# リソース定義

# VPC を作る
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.my_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-${var.my_env}"
  }
}
