# Use existing GitHub OIDC Provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "github-actions-oidc-role-v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:tk53582005/aws-study:*"
          }
        }
      }
    ]
  })

  tags = {
    Name      = "github-actions-oidc-role-v2"
    ManagedBy = "Terraform"
  }
}

# Attach AdministratorAccess policy
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach IAMReadOnlyAccess policy (for Terraform state reading)
resource "aws_iam_role_policy_attachment" "github_actions_iam_readonly" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# Output the role ARN
output "github_actions_role_arn" {
  description = "GitHub Actions OIDC Role ARN"
  value       = aws_iam_role.github_actions.arn
}
