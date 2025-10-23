variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1" # Altere para sua região padrão
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR."
  type        = string
}

variable "scan_on_push" {
  description = "Habilita varredura de imagem (Image Scanning) no push."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags para aplicar aos recursos."
  type        = map(string)
  default     = {}
}