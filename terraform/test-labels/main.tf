terraform {
  required_version = ">= 1.1.6"
}

module "label" {
    source = "git@github.com:Cinnamon/terraform-null-labels.git"
    product = "dso"
    tenant = "test"
    # environment = "us-east-1a"
    project_code = "abc"
    stage = "dev"
    name = "app"
}
