resource "aws_secretsmanager_secret" "app" {
  name = var.name
  tags = var.tags
  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id     = aws_secretsmanager_secret.app.id
  secret_string = jsonencode(var.secrets)
} 