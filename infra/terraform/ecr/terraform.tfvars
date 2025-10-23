aws_region          = "us-east-1"
ecr_repository_name = "monolith-fargate"
scan_on_push        = true

tags = {
  Environment = "development"
  Owner       = "DevopsProjectsLab"
}