resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_names["web"]
  platform_id = var.vm_web_platform_id
  zone = "ru-central1-a"
  resources {
  cores         = var.vms_resources["web"].cores
  memory        = var.vms_resources["web"].memory
  core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_web_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }
  metadata = var.var_metadata

}


resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_names["db"]
  platform_id = var.vm_db_platform_id
  zone = "ru-central1-a"
  resources {
  cores         = var.vms_resources["db"].cores
  memory        = var.vms_resources["db"].memory
  core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_db_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }

  metadata = var.var_metadata


}
