resource "aws_s3_bucket" "this" {
  bucket = github_actions_environment_secret.this.encrypted_value
}

resource "github_actions_environment_secret" "this" {
  repository      = "example"
  environment     = "test"
  secret_name     = "TEST"
  encrypted_value = "tlb8nIdbjGYL9xAGpCXSQaD+ofXFfiXe/OS/C0mebwZgfZgPgsLDSmIDUifgdqIYvMPQGQ=="
}
