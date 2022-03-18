provider "aws" {
  region   = "ap-northeast-1"
  profile  = "dso"
}

terraform {
  backend "s3" {
    bucket         = "cinnamon-terraform-state"
    key            = "dso/tmp/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "cinnamon-terraform-state-lock"
  }
}

module "ec2-instance" {
  source = "git@github.com:Cinnamon/terraform-aws-ec2-instance.git"

  product      = "dso"

  name              = "tmp"
  ami               = "ami-04204a8960917fd92" # Amazon Linux 2 AMI
  availability_zone = "ap-northeast-1a"
  subnet_id         = "subnet-3430b17c"

  instance_type               = "t3a.nano"
  key_name                    = "devops-02-march-2022"
  associate_public_ip_address = true
  disable_api_termination     = false

  root_block_device = [
    { "volume_size" = "50" }
  ]

  # security group
  create_sg           = true
  vpc_id              = "vpc-c4f83fa2"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  user_data_base64 = "I2Nsb3VkLWNvbmZpZwpwYWNrYWdlX3VwZ3JhZGU6IHRydWUKcnVuY21kOgogIC0gc3VkbyBjdXJsIC1MICJodHRwczovL2dpdGh1Yi5jb20vZG9ja2VyL2NvbXBvc2UvcmVsZWFzZXMvZG93bmxvYWQvMS4yNS40L2RvY2tlci1jb21wb3NlLSQodW5hbWUgLXMpLSQodW5hbWUgLW0pIiAtbyAvdXNyL2xvY2FsL2Jpbi9kb2NrZXItY29tcG9zZQogIC0gc3VkbyBjaG1vZCAreCAvdXNyL2xvY2FsL2Jpbi9kb2NrZXItY29tcG9zZQogIC0gY3VybCAiaHR0cHM6Ly9hd3NjbGkuYW1hem9uYXdzLmNvbS9hd3NjbGktZXhlLWxpbnV4LXg4Nl82NC56aXAiIC1vICJhd3NjbGl2Mi56aXAiCiAgLSB1bnppcCBhd3NjbGl2Mi56aXAKICAtIHN1ZG8gLi9hd3MvaW5zdGFsbApwb3dlcl9zdGF0ZToKICBtb2RlOiByZWJvb3QKICBtZXNzYWdlOiBSZXN0YXJ0aW5nIGFmdGVyIGluc3RhbGxpbmcgZG9ja2VyLWNvbXBvc2U="
}