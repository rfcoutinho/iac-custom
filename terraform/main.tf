provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {}
}

locals {
  name = "infra"
}
