provider "aws" {
  region = local.region
  # Update with your profile 
  profile = "cloud_user"

  /* 
  Optional, cloud_user will assume the AWS Resource Administrator 
  role to provision resources.
  */
  # assume_role {
  #   role_arn = "arn:aws:iam::Account_ID:role/terraform_admin"
  #   session_name = "TerraformSession"
  # }
}

terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.49"
    }
  }
}