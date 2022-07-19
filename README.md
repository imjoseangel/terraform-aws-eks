# AWS EKS Terraform module

[![Terraform](https://github.com/imjoseangel/terraform-aws-kubernetes/actions/workflows/terraform.yml/badge.svg)](https://github.com/imjoseangel/terraform-aws-kubernetes/actions/workflows/terraform.yml)

## Deploy a Terraform AWS Kubernetes Service

Terraform module to create an Elastic Kubernetes (EKS) cluster and associated resources

### NOTES

* None

## Usage in Terraform 1.0

```terraform
module "eks" {
  source               = "github.com/imjoseangel/terraform-aws-kubernetes"
}
```

## Authors

Originally created by [imjoseangel](http://github.com/imjoseangel)

## License

[MIT](LICENSE)
