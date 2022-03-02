resource "maas_instance" "my_instance" {
  count               = 1
  release_erase       = false
  release_erase_quick = true
  tags                = var.MAAS_MACHINE_TAGS
  user_data           = file("${path.module}/user_data/preinstall_packages.yml")
  comment             = "deployment with Hashicorp Terraform ;)"
}
