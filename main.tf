terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ohary37"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

  cloud {
   organization = "ohary37"
   workspaces {
     name = "terra-house-1"
   }
  }

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_fancycars_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.fancycars.public_path
  content_version = var.fancycars.content_version
}

resource "terratowns_home" "home_fancycars" {
  name = "Best Luxury Cars in 2023"
  description = <<DESCRIPTION
A luxury car is a car that provides above-average 
to high-end levels of comfort, features, and equipment. 
These vehicles are designed with an emphasis on comfort, 
style, and performance, often featuring advanced technology 
and high-quality materials. They are typically associated with 
wealth and status, and are often a symbol of success and power.
DESCRIPTION
  domain_name = module.home_fancycars_hosting.domain_name
  town = "missingo"
  content_version = var.fancycars.content_version
}

module "home_egusi_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.egusi.public_path
  content_version = var.egusi.content_version
}

resource "terratowns_home" "home_egusi" {
  name = "Making your delicious Egusi Soup"
  description = <<DESCRIPTION
Egusi soup, a traditional Nigerian soup, is a hearty 
and nutritious dish that is a staple in many Nigerian households.
The soup is often served with a variety of ingredients, including meat, 
seafood, or vegetables, depending on the region and the individual's preference. 
Egusi soup is not just a meal, but a cultural dish that brings people together. 
It's a testament to the creativity and resourcefulness of Nigerian cuisine.
DESCRIPTION
  domain_name = module.home_egusi_hosting.domain_name
  town = "missingo"
  content_version = var.egusi.content_version
}