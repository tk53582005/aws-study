# CloudWatch Logs Group for Application Logs
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ec2/${var.project_name}-app"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-app-logs"
  }
}

# CloudWatch Logs Group for ALB Access Logs
resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/elasticloadbalancing/${var.project_name}-alb"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-alb-logs"
  }
}

# SNS Topic for CloudWatch Alarms
resource "aws_sns_topic" "alarms" {
  name         = "${var.project_name}-alarm-topic"
  display_name = "AWS Study Alarm Notifications"

  tags = {
    Name = "${var.project_name}-alarm-topic"
  }
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "alarm_email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch Alarm for EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name          = "${var.project_name}-ec2-cpu-alarm"
  alarm_description   = "CPU使用率が${var.cpu_alarm_threshold}%を超えた時に通知"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "${var.project_name}-ec2-cpu-alarm"
  }
}
