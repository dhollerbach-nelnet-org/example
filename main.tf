resource "github_actions_environment_secret" "test_secret" {
  repository      = "example"
  environment     = "test"
  secret_name     = "TEST"
  encrypted_value = "tlb8nIdbjGYL9xAGpCXSQaD+ofXFfiXe/OS/C0mebwZgfZgPgsLDSmIDUifgdqIYvMPQGQ=="
}
