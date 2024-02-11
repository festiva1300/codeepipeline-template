variable pipeline_name {}
variable build_project_name {}
variable source_branch_name {}
variable source_repository_arn {}
variable source_repository_name {}
variable artifact_store_name {}

resource "aws_codepipeline" "codepipeline" {
    name = var.pipeline_name
    role_arn = "${aws_iam_role.CodePipelineIAMRole.arn}"
    artifact_store {
        location = "${aws_s3_bucket.CodePipelineArtifactBacket.id}"
        type = "S3"
    }
    stage {
        name = "Source"
        action {
          name = "Source"
          category = "Source"
          owner = "AWS"
          configuration = {
              BranchName = var.source_branch_name
              ConnectionArn = var.source_repository_arn
              DetectChanges = "true"
              FullRepositoryId = var.source_repository_name
              OutputArtifactFormat = "CODE_ZIP"
          }
          provider = "CodeStarSourceConnection"
          version = "1"
          output_artifacts = [
              "SourceArtifact"
          ]
          run_order = 1
        }
    }
    stage {
        name = "Build"
        action {
          name = "Build"
          category = "Build"
          owner = "AWS"
          configuration = {
              ProjectName = var.build_project_name
          }
          input_artifacts = [
              "SourceArtifact"
          ]
          provider = "CodeBuild"
          version = "1"
          output_artifacts = [
              "BuildArtifact"
          ]
          run_order = 1
        }       
    }
}

resource "aws_s3_bucket" "CodePipelineArtifactBacket" {
  bucket = var.artifact_store_name
}

resource "aws_iam_role" "CodePipelineIAMRole" {
  name = "${var.pipeline_name}_CodePipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pipeline" {
  role       = aws_iam_role.CodePipelineIAMRole.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

output "codepipeline_arn" {
  value = aws_codepipeline.codepipeline.arn
}
