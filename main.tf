module "codepipeline" {
  source                    = "./modules/codepipeline"
  source_repository_name    = "githubuser/repository_name"
  source_repository_arn     = "arn:aws:codestar-connections:us-east-1:999999999999:connection/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  source_branch_name        = "main"
  artifact_store_name       = "codepipeline-artifact-999999999999"
  pipeline_name             = "samplePipeline"
  build_project_name        = "sampleCodeBuild"
}
module "codebuild" {
  project_name              = "sampleCodeBuild"
  source                    = "./modules/codebuild"
  ecr_region                = "us-east-1"
  ecr_account               = "999999999999"
  ecr_repository_name       = "example-app"
  image_tag                 = "latest"
}