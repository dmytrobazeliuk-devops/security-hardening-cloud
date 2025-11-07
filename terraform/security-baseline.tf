# Security Baseline Configuration
# Implements security best practices for cloud infrastructure

# CloudTrail
resource "aws_cloudtrail" "security_audit" {
  name                          = "security-audit-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation   = true

  event_selector {
    read_write_type                 = "All"
    include_management_events      = true
    exclude_management_event_sources = []
  }

  tags = {
    Name = "security-audit-trail"
    Purpose = "security-hardening"
  }
}

# S3 Bucket for CloudTrail
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.bucket_prefix}-cloudtrail-logs"
  force_destroy = false

  tags = {
    Name = "cloudtrail-logs"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket names"
  type        = string
  default     = "security"
}

# GuardDuty
resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

# Security Hub
resource "aws_securityhub_account" "main" {
  enable_default_standards = true
}

# AWS Config
resource "aws_config_configuration_recorder" "main" {
  name     = "security-config-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "main" {
  name           = "security-config-delivery"
  s3_bucket_name = aws_s3_bucket.config.id
}

# IAM Role for Config
resource "aws_iam_role" "config" {
  name = "config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# S3 Bucket for Config
resource "aws_s3_bucket" "config" {
  bucket = "${var.bucket_prefix}-config-logs"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM Password Policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  hard_expiry                    = false
  allow_users_to_change_password = true
}

