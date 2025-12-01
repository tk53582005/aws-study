terraform {
  backend "s3" {
    bucket = "tfstate-922092352781-handson" # ←あなたが作ったバケット名
    key    = "chapter-5/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
