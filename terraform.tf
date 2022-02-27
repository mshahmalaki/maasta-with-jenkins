terraform {
  required_providers {
    maas = {
      source = "suchpuppet/maas"
    }
  }
  backend "s3" {
    endpoint                    = "http://192.168.121.14:9000"
    bucket                      = "terraform"
    region                      = "main"
    key                         = "terraform.tfstate"
    access_key                  = "5f94956791a8d768"
    secret_key                  = "02e3250e6d7a1b56"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
    workspace_key_prefix        = "tfstate"
  }
}
