# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket               = "tfstate-922092352781-handson"
    workspace_key_prefix = "chapter-7"
    key                  = "terraform.tfstate"
    region               = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
