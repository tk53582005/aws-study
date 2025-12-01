# IAM Role for EC2 to write CloudWatch Logs
resource "aws_iam_role" "ec2_log_role" {
  name = "${var.project_name}-ec2-log-role-new"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-log-role-new"
  }
}

# Attach CloudWatch Agent Server Policy
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_log_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-instance-profile-new"
  role = aws_iam_role.ec2_log_role.name

  tags = {
    Name = "${var.project_name}-ec2-instance-profile-new"
  }
}