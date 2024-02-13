resource "github_actions_environment_secret" "test_secret" {
  repository      = "example"
  environment     = "test"
  secret_name     = "TEST"
  encrypted_value = "tlb8nIdbjGYL9xAGpCXSQaD+ofXFfiXe/OS/C0mebwZgfZgPgsLDSmIDUifgdqIYvMPQGQ=="
}


resource "aws_secretsmanager_secret" "this" {
  name = "github-actions-test"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
}

