resource "yandex_compute_instance" "web" {
  count = 2
  name  = "web-${count.index + 1}"
  hostname = "web-${count.index + 1}"
  platform_id = "standard-v1"

  depends_on = [
  yandex_compute_instance.db_vm["main"],
  yandex_compute_instance.db_vm["replica"]
]

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 5
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