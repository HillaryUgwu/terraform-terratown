terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ohary37"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  # cloud {
  #  organization = "ohary37"
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
}