data "aws_partition" "current" {}

################################################################################
# IAM Role
################################################################################

locals {
  create_iam_role   = var.create && var.create_iam_role
  iam_role_name     = coalesce(var.iam_role_name, "${var.cluster_name}-cluster")
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  dns_suffix = data.aws_partition.current.dns_suffix
}

output "dns_suffix" {
  value = local.dns_suffix
}
