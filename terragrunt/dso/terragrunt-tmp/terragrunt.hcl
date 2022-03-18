terraform {
  source = "git@github.com:Cinnamon/terraform-aws-ec2-instance.git"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
