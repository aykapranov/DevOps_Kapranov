resource "yandex_compute_disk" "vm_disc_test" {
  count = 3
  name  = "data-disk-${count.index}"
  size  = 5 
  zone  = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  zone = var.default_zone
  hostname = "storage"

  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.vm_disc_test
    content {
      disk_id = secondary_disk.value.id
      auto_delete = true
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
