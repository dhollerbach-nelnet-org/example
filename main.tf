resource "github_actions_environment_secret" "test_secret" {
  repository      = "example"
  environment     = "test"
  secret_name     = var.secret_name
  encrypted_value = "fwmBTjH7jNiaqG4N8EK32N4jmUOs2j14RgoPHBWh127hKwzaJH3w1CRxKjthsI7akZYEyw=="
}


resource "aws_secretsmanager_secret" "this" {
  name = "github-actions-test"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
}

