data "aws_partition" "main" {}
data "aws_caller_identity" "main" {}

################################################################################
# IAM Role
################################################################################

locals {
  iam_role_name          = coalesce(var.iam_role_name, "${var.name}-node-group")
  iam_role_policy_prefix = "arn:${data.aws_partition.main.partition}:iam::aws:policy"
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.create_iam_role ? 1 : 0

  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.main.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create && var.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}
