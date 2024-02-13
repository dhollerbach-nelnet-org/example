provider "aws" {}

resource "aws_s3_bucket" "this" {
  bucket = "oau2i2ndadv923n--213rvnqv-128"
}


# GITHUB
provider "github" {}

data "github_repository" "this" {
  full_name = "dhollerbach-nelnet-org/example"
}

resource "github_repository_environment" "this" {
  repository       = data.github_repository.this.name
  environment      = "example"
}

resource "github_actions_environment_secret" "test_secret" {
  repository       = data.github_repository.repo.name
  environment      = github_repository_environment.this.environment
  secret_name      = "test_secret_name"
  plaintext_value  = "%s"
}
