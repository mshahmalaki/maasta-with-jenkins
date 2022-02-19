resource "maas_instance" "myinstance" {
  count = 2
  release_erase = false
  release_erase_quick = true
  tags = [ "for-terraform-provisioning" ]
}