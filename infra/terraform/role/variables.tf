variable "aws_region" {
  description = "A região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "ID de conta AWS (12 dígitos)."
  type        = string
}

variable "github_repo_slug" {
  description = "Slug do repositório GitHub (ex: DevOpsProjectsLab/monolith-to-fargate)."
  type        = string
}

variable "iam_role_name" {
  description = "Nome da Role IAM a ser criada para o GitHub OIDC."
  type        = string
  default     = "GitHub-OIDC-ECR-Deploy-Role"
}

variable "iam_group_name_for_assume" {
  description = "O nome do Grupo IAM cujos membros podem assumir esta Role (ex: Terraform)."
  type        = string
  default     = "Terraform" # Nome do grupo IAM existente.
}