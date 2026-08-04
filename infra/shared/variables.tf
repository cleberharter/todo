variable "location" {
  type        = string
  description = "Azure region for the shared resources"
  default     = "eastus2"
}

variable "project_name" {
  type        = string
  description = "Base name used to build resource names"
  default     = "todo"
}
