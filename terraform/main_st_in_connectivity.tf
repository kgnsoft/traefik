provider "aws" {
  region = var.aws_region
  version = "2.16.0"

#assume_role {
#  role_arn     = "arn:aws:iam::260563756810:role/TerraformBuild"
#  session_name = "deploy_inbound_proxy"
#  external_id  = "Anis"
#}
}

terraform {
  backend "s3" {
    bucket = "ncds-terraform-connectivity"
    key    = "nonprod/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "ncds-terraform-connectivity-locks"
#    role_arn = "arn:aws:iam::202696833239:role/TerraformBuild"
  }
}

