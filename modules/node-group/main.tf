data "aws_partition" "main" {}
data "aws_caller_identity" "main" {}

################################################################################
# IAM Role
################################################################################

locals {
  iam_role_policy_prefix = "arn:${data.aws_partition.main.partition}:iam::aws:policy"
  cni_policy             = var.cluster_ip_family == "ipv6" ? "arn:${data.aws_partition.main.partition}:iam::${data.aws_caller_identity.main.account_id}:policy/AmazonEKS_CNI_IPv6_Policy" : "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
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

resource "aws_iam_role" "main" {
  count                 = var.create && var.create_iam_role ? 1 : 0
  name                  = var.iam_role_name
  description           = var.iam_role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "main" {
  for_each = var.create && var.create_iam_role ? toset(compact(distinct(concat([
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    var.iam_role_attach_cni_policy ? local.cni_policy : "",
  ], var.iam_role_additional_policies)))) : toset([])

  policy_arn = each.value
  role       = aws_iam_role.main[0].name
}
