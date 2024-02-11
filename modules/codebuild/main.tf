variable project_name {}
variable ecr_account {}
variable ecr_region {}
variable ecr_repository_name {}
variable image_tag {}

resource "aws_codebuild_project" "dockerBuild" {
  name          = var.project_name
  description   = "Project to execute docker build and deploy"
  build_timeout = "5"
  service_role  = aws_iam_role.CodeBuildIAMRole.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.ecr_account
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.ecr_region
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

resource "aws_iam_role" "CodeBuildIAMRole" {
  name = "${var.project_name}_CodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.CodeBuildIAMRole.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
