output "github_oidc_iam_role_arn" {
  description = "O ARN da Role IAM criada. Use isso no seu fluxo de trabalho do GitHub Actions."
  value       = aws_iam_role.github_oidc_role.arn
}

output "github_oidc_iam_role_name" {
  description = "O nome da Role IAM."
  value       = aws_iam_role.github_oidc_role.name
}