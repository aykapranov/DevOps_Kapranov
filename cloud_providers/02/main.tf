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

# Создать бакет Object Storage и разместить в нём файл с картинкой:

resource "yandex_storage_bucket" "my_bucket" {
  bucket = var.bucket_name
}

resource "yandex_storage_bucket_grant" "public_read" {

  bucket = yandex_storage_bucket.my_bucket.bucket

  grant {
    uri = "http://acs.amazonaws.com/groups/global/AllUsers"
    permissions = ["READ"]
    type = "Group"
  }
}

resource "yandex_storage_object" "image" {

  bucket = yandex_storage_bucket.my_bucket.bucket
  key = "picture.png"
  source = "${path.module}/picture.png"
}

# Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

resource "yandex_compute_instance_group" "lamp_group" {
  name = "lamp-group"
  folder_id = var.folder_id
  service_account_id = var.sa_id
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores = 2
      memory = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat = true
    }

    metadata = {
      ssh-keys = "ubuntu:${var.vms_ssh_root_key[0]}"
      user-data = <<-EOT
        #!/bin/bash
        echo '<html><head><title>Test</title></head><body><h1>Instance</h1><img src="https://storage.yandexcloud.net/bucket-20251024/picture.png"/></body></html>' > /var/www/html/index.html
      EOT
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  health_check {
    interval = 10
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 3
    http_options {
      port = 80
      path = "/"
    }
  }


  deploy_policy {
    max_unavailable = 1
    max_expansion = 1
  }
}

# 3. Подключить группу к сетевому балансировщику:
resource "yandex_lb_target_group" "lamp_targets" {
  name = "lamp-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address = yandex_compute_instance_group.lamp_group.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address = yandex_compute_instance_group.lamp_group.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address = yandex_compute_instance_group.lamp_group.instances[2].network_interface[0].ip_address
  }
}

# 2. Network Load Balancer
resource "yandex_lb_network_load_balancer" "lamp_nlb" {
  name = "lamp-nlb"

  listener {
    name = "http-listener"
    port = 80
    target_port = 80
    protocol = "tcp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp_targets.id

    healthcheck {
      name = "http-hc"
      tcp_options {
        port = 80
      }
    }
  }
}
