# tests/vpc.tftest.hcl

# テスト用の変数を設定
variables {
  db_master_password = "TestPassword123!"
  db_master_username = "admin"
  key_name          = "aws-study-key"
  alarm_email       = "test@example.com"
  my_ip             = "0.0.0.0/32"
}

run "vpc_configuration_test" {
  command = plan

  # VPCのCIDRブロックが正しいか
  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPCのCIDRブロックが想定値(10.0.0.0/16)と異なります"
  }

  # DNS サポートが有効か
  assert {
    condition     = aws_vpc.main.enable_dns_support == true
    error_message = "VPCのDNSサポートが有効になっていません"
  }

  # DNS ホスト名が有効か
  assert {
    condition     = aws_vpc.main.enable_dns_hostnames == true
    error_message = "VPCのDNSホスト名が有効になっていません"
  }

  # VPCタグが正しいか
  assert {
    condition = aws_vpc.main.tags["Name"] == "aws-study-v2-vpc-v2"
    error_message = "VPCのタグ名が想定と異なります"
  }
}

run "public_subnet_1_test" {
  command = plan

  # Public Subnet 1のCIDRブロック
  assert {
    condition     = aws_subnet.public_1.cidr_block == "10.0.1.0/24"
    error_message = "Public Subnet 1のCIDRブロックが想定値(10.0.1.0/24)と異なります"
  }

  # パブリックIPの自動割り当てが有効か
  assert {
    condition     = aws_subnet.public_1.map_public_ip_on_launch == true
    error_message = "Public Subnet 1でパブリックIPの自動割り当てが有効になっていません"
  }
}

run "public_subnet_2_test" {
  command = plan

  # Public Subnet 2のCIDRブロック
  assert {
    condition     = aws_subnet.public_2.cidr_block == "10.0.2.0/24"
    error_message = "Public Subnet 2のCIDRブロックが想定値(10.0.2.0/24)と異なります"
  }

  # パブリックIPの自動割り当てが有効か
  assert {
    condition     = aws_subnet.public_2.map_public_ip_on_launch == true
    error_message = "Public Subnet 2でパブリックIPの自動割り当てが有効になっていません"
  }
}

run "private_subnet_1_test" {
  command = plan

  # Private Subnet 1のCIDRブロック
  assert {
    condition     = aws_subnet.private_1.cidr_block == "10.0.11.0/24"
    error_message = "Private Subnet 1のCIDRブロックが想定値(10.0.11.0/24)と異なります"
  }

  # パブリックIPの自動割り当てが無効か（デフォルトfalse）
  assert {
    condition     = aws_subnet.private_1.map_public_ip_on_launch == false
    error_message = "Private Subnet 1でパブリックIPの自動割り当てが無効になっていません"
  }
}

run "private_subnet_2_test" {
  command = plan

  # Private Subnet 2のCIDRブロック
  assert {
    condition     = aws_subnet.private_2.cidr_block == "10.0.12.0/24"
    error_message = "Private Subnet 2のCIDRブロックが想定値(10.0.12.0/24)と異なります"
  }

  # パブリックIPの自動割り当てが無効か
  assert {
    condition     = aws_subnet.private_2.map_public_ip_on_launch == false
    error_message = "Private Subnet 2でパブリックIPの自動割り当てが無効になっていません"
  }
}

run "route_configuration_test" {
  command = plan

  # インターネットへのルートが正しいか
  assert {
    condition     = aws_route.public_internet_gateway.destination_cidr_block == "0.0.0.0/0"
    error_message = "インターネットへのルートのCIDRが0.0.0.0/0ではありません"
  }
}