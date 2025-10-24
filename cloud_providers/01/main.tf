# VPC
resource "yandex_vpc_network" "vpc" {
  name = "main-vpc"
}

# Subnet: public
resource "yandex_vpc_subnet" "public" {
  name = "public"
  zone = var.default_zone
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# ВМ с NAT-инстанс
resource "yandex_compute_instance" "nat_instance" {
  name = "nat-instance"
  hostname = "nat"
  zone = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key[0]}"
  }
}

# ВМ с публичным IP
resource "yandex_compute_instance" "vm_public" {
  name = "vm-public"
  hostname = "vm-public"
  zone = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key[0]}"
  }
}

# Получаем Ubuntu 24.04
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

# Приватная подсеть
resource "yandex_vpc_subnet" "private" {
  name = "private"
  zone = var.default_zone
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Таблица маршрутов
resource "yandex_vpc_route_table" "private_rt" {
  network_id = yandex_vpc_network.vpc.id
  name = "private-rt"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "192.168.10.254" # IP NAT-инстанса
  }
}

# ВМ в приватной сети
resource "yandex_compute_instance" "vm_private" {
  name = "vm-private"
  hostname = "vm-private"
  zone = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key[0]}"
  }
}