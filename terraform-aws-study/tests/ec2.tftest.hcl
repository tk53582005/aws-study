# tests/ec2.tftest.hcl

# テスト用の変数を設定
variables {
  db_master_password = "TestPassword123!"
  db_master_username = "admin"
  key_name           = "aws-study-key"
  alarm_email        = "test@example.com"
  my_ip              = "124.209.89.41/32"
}

run "ec2_instance_test" {
  command = plan

  # インスタンスタイプが正しいか
  assert {
    condition     = aws_instance.main.instance_type == "t2.micro"
    error_message = "EC2インスタンスタイプがt2.microではありません"
  }

  # キーペア名が正しいか
  assert {
    condition     = aws_instance.main.key_name == "aws-study-key"
    error_message = "EC2のキーペア名が想定と異なります"
  }

  # タグが正しいか
  assert {
    condition     = aws_instance.main.tags["Name"] == "aws-study-v2-ec2-updated-v2"
    error_message = "EC2インスタンスのタグ名が想定と異なります"
  }
}

run "ami_validation_test" {
  command = plan

  # Amazon Linux 2023 AMIが使用されているか（名前パターンで確認）
  assert {
    condition     = length(regexall("^al2023-ami-.*-x86_64$", data.aws_ami.amazon_linux_2023.name)) > 0
    error_message = "AMI名がAmazon Linux 2023のパターンと一致しません"
  }

  # 仮想化タイプがHVMか
  assert {
    condition     = data.aws_ami.amazon_linux_2023.virtualization_type == "hvm"
    error_message = "AMIの仮想化タイプがHVMではありません"
  }

  # AMIの状態がavailableか
  assert {
    condition     = data.aws_ami.amazon_linux_2023.state == "available"
    error_message = "AMIの状態がavailableではありません"
  }
}
