variable "name" {
  description = "Name for the secret"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to store"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 