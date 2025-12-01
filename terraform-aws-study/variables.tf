variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "key_name" {
  description = "EC2 KeyPair name for SSH access"
  type        = string
}

variable "db_master_username" {
  description = "Database master username (avoid common names like 'root' or 'admin')"
  type        = string
  # デフォルトなし = 必須入力
}

variable "db_master_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
  # デフォルトなし = 必須入力
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization threshold for CloudWatch alarm (percent)"
  type        = number
  default     = 70

  validation {
    condition     = var.cpu_alarm_threshold >= 1 && var.cpu_alarm_threshold <= 100
    error_message = "CPU alarm threshold must be between 1 and 100."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}

variable "db_backup_retention_period" {
  description = "Number of days to retain automated backups (0-35)"
  type        = number
  default     = 7

  validation {
    condition     = var.db_backup_retention_period >= 0 && var.db_backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS (set false for production)"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev/staging/production)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "aws-study-v2"
}
