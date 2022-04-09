terraform {
  required_providers {
    maas = {
      source = "suchpuppet/maas"
    }
  }
  backend "s3" {
    region                      = "main"
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
