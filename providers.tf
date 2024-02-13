provider "aws" {}

provider "github" {
  owner = "dhollerbach-nelnet-org"
  token = var.token
}
