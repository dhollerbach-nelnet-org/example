# provider "aws" {}

# resource "aws_s3_bucket" "this" {
#   bucket = "oau2i2ndadv923n--213rvnqv-128"
# }


# GITHUB
provider "github" {
  owner = "dhollerbach-nelnet-org"
  token = var.token
}

variable "token" {}

resource "github_actions_environment_secret" "test_secret" {
  repository      = "example"
  environment     = "test"
  secret_name     = "TEST"
  plaintext_value = "test"
}
