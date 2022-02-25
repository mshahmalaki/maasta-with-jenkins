resource "maas_instance" "testing" {
  count = 2
  release_erase = false
  release_erase_quick = true
  tags = [ "testing" ]
}

resource "maas_instance" "production" {
  count = 2
  release_erase = false
  release_erase_quick = true
  tags = [ "prod" ]
}