output "role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "role_name" {
  value = aws_iam_role.ecs_task_execution.name
} 