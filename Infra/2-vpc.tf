resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


/* To enable DNS support in VPC, it is requirement from some addons
like EFS CSI driver, VPN */
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.cluster_name}-vpc"
  }
}
