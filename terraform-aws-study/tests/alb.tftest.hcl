# tests/alb.tftest.hcl

# テスト用の変数を設定
variables {
  db_master_password = "TestPassword123!"
  db_master_username = "admin"
  key_name           = "aws-study-key"
  alarm_email        = "test@example.com"
  my_ip              = "124.209.89.41/32"
}

run "alb_configuration_test" {
  command = plan

  # ALB名が正しいか
  assert {
    condition     = aws_lb.main.name == "aws-study-v2-alb-v2"
    error_message = "ALB名が想定と異なります"
  }

  # 内部ALBではないか（インターネット向け）
  assert {
    condition     = aws_lb.main.internal == false
    error_message = "ALBが内部ALBになっています（インターネット向けであるべき）"
  }

  # ロードバランサータイプがapplicationか
  assert {
    condition     = aws_lb.main.load_balancer_type == "application"
    error_message = "ロードバランサータイプがapplicationではありません"
  }

  # タグが正しいか
  assert {
    condition     = aws_lb.main.tags["Name"] == "aws-study-v2-alb-v2"
    error_message = "ALBのタグ名が想定と異なります"
  }
}

run "target_group_test" {
  command = plan

  # ターゲットグループ名が正しいか
  assert {
    condition     = aws_lb_target_group.main.name == "aws-study-v2-tg-v2"
    error_message = "ターゲットグループ名が想定と異なります"
  }

  # ポートが8080か
  assert {
    condition     = aws_lb_target_group.main.port == 8080
    error_message = "ターゲットグループのポートが8080ではありません"
  }

  # プロトコルがHTTPか
  assert {
    condition     = aws_lb_target_group.main.protocol == "HTTP"
    error_message = "ターゲットグループのプロトコルがHTTPではありません"
  }

  # ヘルスチェックが有効か
  assert {
    condition     = aws_lb_target_group.main.health_check[0].enabled == true
    error_message = "ヘルスチェックが有効になっていません"
  }

  # ヘルスチェックパスが正しいか
  assert {
    condition     = aws_lb_target_group.main.health_check[0].path == "/"
    error_message = "ヘルスチェックパスが想定と異なります"
  }

  # ヘルスチェックの healthy_threshold が正しいか
  assert {
    condition     = aws_lb_target_group.main.health_check[0].healthy_threshold == 2
    error_message = "ヘルスチェックのhealthy_thresholdが2ではありません"
  }

  # ヘルスチェックの unhealthy_threshold が正しいか
  assert {
    condition     = aws_lb_target_group.main.health_check[0].unhealthy_threshold == 2
    error_message = "ヘルスチェックのunhealthy_thresholdが2ではありません"
  }

  # ヘルスチェックタイムアウトが正しいか
  assert {
    condition     = aws_lb_target_group.main.health_check[0].timeout == 5
    error_message = "ヘルスチェックタイムアウトが5秒ではありません"
  }

  # ヘルスチェック間隔が正しいか
  assert {
    condition     = aws_lb_target_group.main.health_check[0].interval == 30
    error_message = "ヘルスチェック間隔が30秒ではありません"
  }
}

run "alb_listener_test" {
  command = plan

  # リスナーポートが80か
  assert {
    condition     = aws_lb_listener.main.port == 80
    error_message = "ALBリスナーのポートが80ではありません"
  }

  # リスナープロトコルがHTTPか
  assert {
    condition     = aws_lb_listener.main.protocol == "HTTP"
    error_message = "ALBリスナーのプロトコルがHTTPではありません"
  }

  # デフォルトアクションタイプがforwardか
  assert {
    condition     = aws_lb_listener.main.default_action[0].type == "forward"
    error_message = "ALBリスナーのデフォルトアクションがforwardではありません"
  }
}

run "target_group_attachment_test" {
  command = plan

  # ターゲットグループアタッチメントのポートが8080か
  assert {
    condition     = aws_lb_target_group_attachment.main.port == 8080
    error_message = "ターゲットグループアタッチメントのポートが8080ではありません"
  }
}