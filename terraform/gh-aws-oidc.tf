data "tls_certificate" "default" {
  url = "tls://token.actions.githubusercontent.com:443"
}

resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.default.arn]
    }

    condition {
      test = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values    = ["sts.amazonaws.com"]
    }

    condition {
      test = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values    = ["repo:omar-farooq/gobasictest:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_policy" "ecr_deploy" {
  name = "AmazonECRDeploy"
  
  policy = jsonencode({
    Version     = "2012-10-17"
    Statement   = [
      {
        Action = ["ecr:DescribeImages", "ecr:DescribeRepositories", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability", "ecr:CompleteLayerUpload", "ecr:InitiateLayerUpload", "ecr:PutImage", "ecr:UploadLayerPart", "ecr:GetDownloadUrlForLayer", "ecr:GetAuthorizationToken"]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "github_actions" {
  name_prefix = "GHActions"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.ecr_deploy.arn]
}
