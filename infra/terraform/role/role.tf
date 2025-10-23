data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_group" "terraform_group" {
  group_name = var.iam_group_name_for_assume
}

data "aws_iam_policy_document" "github_oidc_trust_policy" {

  # Permite o Acesso OIDC do GitHub
  statement {
    sid     = "GitHubOIDC"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo_slug}:*"]
    }
  }

  # Permite que o Grupo 'Terraform' Assuma a Role (Usuário infrascode)
  statement {
    sid     = "AllowUserGroupAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # Permite que todos os membros do Grupo 'Terraform' assumam esta Role
      identifiers = [data.aws_iam_group.terraform_group.arn]
    }
  }
}

resource "aws_iam_role" "github_oidc_role" {
  name                 = var.iam_role_name
  assume_role_policy   = data.aws_iam_policy_document.github_oidc_trust_policy.json
  description          = "IAM Role para GitHub Actions via OIDC e acesso manual pelo time Terraform."
  max_session_duration = 3600
}

resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
