# tests/rds.tftest.hcl

# テスト用の変数を設定
variables {
  db_master_password = "TestPassword123!"
  db_master_username = "admin"
  key_name           = "aws-study-key"
  alarm_email        = "test@example.com"
  my_ip              = "0.0.0.0/32"
}

run "rds_instance_test" {
  command = plan

  # エンジンがMySQLか
  assert {
    condition     = aws_db_instance.main.engine == "mysql"
    error_message = "RDSエンジンがMySQLではありません"
  }

  # エンジンバージョンが正しいか
  assert {
    condition     = aws_db_instance.main.engine_version == "8.0.39"
    error_message = "MySQLバージョンが8.0.39ではありません"
  }

  # インスタンスクラスが正しいか
  assert {
    condition     = aws_db_instance.main.instance_class == "db.t3.micro"
    error_message = "RDSインスタンスクラスがdb.t3.microではありません"
  }

  # ストレージサイズが正しいか
  assert {
    condition     = aws_db_instance.main.allocated_storage == 20
    error_message = "RDSストレージサイズが20GBではありません"
  }

  # ストレージタイプが正しいか
  assert {
    condition     = aws_db_instance.main.storage_type == "gp2"
    error_message = "RDSストレージタイプがgp2ではありません"
  }

  # データベース名が正しいか
  assert {
    condition     = aws_db_instance.main.db_name == "awsstudy"
    error_message = "データベース名がawsstudyではありません"
  }

  # パブリックアクセスが無効か
  assert {
    condition     = aws_db_instance.main.publicly_accessible == false
    error_message = "RDSがパブリックアクセス可能になっています（セキュリティリスク）"
  }

  # マルチAZが無効か（dev環境）
  assert {
    condition     = aws_db_instance.main.multi_az == false
    error_message = "RDSのマルチAZ設定が想定と異なります"
  }

  # バックアップウィンドウが設定されているか
  assert {
    condition     = aws_db_instance.main.backup_window == "03:00-04:00"
    error_message = "RDSバックアップウィンドウが想定と異なります"
  }

  # メンテナンスウィンドウが設定されているか
  assert {
    condition     = aws_db_instance.main.maintenance_window == "mon:04:00-mon:05:00"
    error_message = "RDSメンテナンスウィンドウが想定と異なります"
  }
}

run "rds_subnet_group_test" {
  command = plan

  # サブネットグループ名が正しいか
  assert {
    condition     = aws_db_subnet_group.main.name == "aws-study-v2-db-subnet-group"
    error_message = "RDSサブネットグループ名が想定と異なります"
  }

  # タグが正しいか
  assert {
    condition     = aws_db_subnet_group.main.tags["Name"] == "aws-study-v2-db-subnet-group"
    error_message = "RDSサブネットグループのタグ名が想定と異なります"
  }
}