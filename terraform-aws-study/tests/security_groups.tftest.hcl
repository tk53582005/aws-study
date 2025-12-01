# tests/security_groups.tftest.hcl

# テスト用の変数を設定
variables {
  db_master_password = "TestPassword123!"
  db_master_username = "admin"
  key_name          = "aws-study-key"
  alarm_email       = "test@example.com"
  my_ip             = "124.209.89.41/32"
}

run "alb_security_group_test" {
  command = plan

  # ALB SGの名前が正しいか
  assert {
    condition     = aws_security_group.alb.name == "alb-sg-v2"
    error_message = "ALBセキュリティグループの名前が想定と異なります"
  }

  # HTTP ingress（ポート80）が設定されているか
  assert {
    condition     = length([for rule in aws_security_group.alb.ingress : rule if rule.from_port == 80 && rule.to_port == 80]) > 0
    error_message = "ALBセキュリティグループにHTTP(80)のingressルールが設定されていません"
  }

  # タグが正しいか
  assert {
    condition     = aws_security_group.alb.tags["Name"] == "alb-sg-v2"
    error_message = "ALBセキュリティグループのタグ名が想定と異なります"
  }
}

run "ec2_security_group_test" {
  command = plan

  # EC2 SGの名前が正しいか
  assert {
    condition     = aws_security_group.ec2.name == "ec2-sg-v2"
    error_message = "EC2セキュリティグループの名前が想定と異なります"
  }

  # SSH ingress（ポート22）が設定されているか
  assert {
    condition     = length([for rule in aws_security_group.ec2.ingress : rule if rule.from_port == 22 && rule.to_port == 22]) > 0
    error_message = "EC2セキュリティグループにSSH(22)のingressルールが設定されていません"
  }

  # アプリケーションポート（8080）が設定されているか
  assert {
    condition     = length([for rule in aws_security_group.ec2.ingress : rule if rule.from_port == 8080 && rule.to_port == 8080]) > 0
    error_message = "EC2セキュリティグループにHTTP(8080)のingressルールが設定されていません"
  }

  # タグが正しいか
  assert {
    condition     = aws_security_group.ec2.tags["Name"] == "ec2-sg-v2"
    error_message = "EC2セキュリティグループのタグ名が想定と異なります"
  }
}

run "rds_security_group_test" {
  command = plan

  # RDS SGの名前が正しいか
  assert {
    condition     = aws_security_group.rds.name == "rds-sg-v2"
    error_message = "RDSセキュリティグループの名前が想定と異なります"
  }

  # MySQL ingress（ポート3306）が設定されているか
  assert {
    condition     = length([for rule in aws_security_group.rds.ingress : rule if rule.from_port == 3306 && rule.to_port == 3306]) > 0
    error_message = "RDSセキュリティグループにMySQL(3306)のingressルールが設定されていません"
  }

  # タグが正しいか
  assert {
    condition     = aws_security_group.rds.tags["Name"] == "rds-sg-v2"
    error_message = "RDSセキュリティグループのタグ名が想定と異なります"
  }
}