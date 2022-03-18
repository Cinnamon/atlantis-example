

remote_state {
  backend = "s3"

  config = {
    bucket         = "cinnamon-terraform-state"
    key            = "terragrunt/dso/${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "cinnamon-terraform-state-lock"
    profile        = "dso"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region   = "ap-northeast-1"
  profile  = "dso"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

inputs = merge(
  yamldecode(
    file("${get_terragrunt_dir()}/values.yml"),
  )
)
