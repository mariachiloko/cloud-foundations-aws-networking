output "github_actions_role_name" {
  description = "Name of the IAM role assumed by GitHub Actions through OIDC."
  value       = aws_iam_role.github_actions_role.name
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions through OIDC."
  value       = aws_iam_role.github_actions_role.arn
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider configured in AWS IAM."
  value       = aws_iam_openid_connect_provider.github.arn
}