variable "location" {
  type        = string
  description = "Azure region for the shared resources"
  default     = "brazilsouth"
}

variable "project_name" {
  type        = string
  description = "Base name used to build resource names"
  default     = "todo"
}
