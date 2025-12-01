terraform {
  backend "s3" {
    bucket         = "terraform-state-aws-study-terahara"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
