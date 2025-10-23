output "ecr_repository_name" {
  description = "Nome do repositório ECR criado."
  value       = aws_ecr_repository.ecr_repo.name
}

output "ecr_repository_url" {
  description = "URL do repositório ECR (usada para comandos docker push/pull)."
  value       = aws_ecr_repository.ecr_repo.repository_url
}