resource "maas_instance" "testing" {
  count               = 2
  release_erase       = false
  release_erase_quick = true
  tags                = [var.MAAS_MACHINE_TAGS]
}
