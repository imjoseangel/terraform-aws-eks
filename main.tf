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

data "aws_iam_policy_document" "assume_role_policy" {
  count = local.create && var.create_iam_role ? 1 : 0

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }
  }
}
