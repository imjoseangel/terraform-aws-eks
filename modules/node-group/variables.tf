variable "create" {
  description = "Determines whether to create EKS managed node group or not"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "default"
}

################################################################################
# IAM Role
################################################################################

variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}
