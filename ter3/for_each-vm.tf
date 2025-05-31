data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

locals {
  vm_map = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "db_vm" {
  for_each = local.vm_map

  name = each.value.vm_name
  zone = var.default_zone
  hostname = each.value.vm_name

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}

