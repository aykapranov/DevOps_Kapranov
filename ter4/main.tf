locals {
  ssh_keys_yaml = join("\n  - ", var.vms_ssh_root_key)

  cloudinit = templatefile("${path.module}/cloud-init.yml", {
    ssh_keys_yaml = local.ssh_keys_yaml
  })
}

module "vpc_dev" {
  source = "./modules/vpc"
  network_name = "dev-network"
  subnet_name = "dev-subnet"
  zone = "ru-central1-a"
  v4_cidr_blocks = ["10.10.0.0/24"]       
}


module "analytics-vm" {
  source         = "./modules/yandex_compute_instance"
  env_name       = "analytics"
  network_id = module.vpc_dev.network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids = [module.vpc_dev.subnet_id]
  instance_name  = "analytics-vm"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    owner   = "team-analytics"
    project = "analytics"
  }

  metadata = {
    user-data          = local.cloudinit
    serial-port-enable = "1"
  }
}

module "marketing-vm" {
  source         = "./modules/yandex_compute_instance"
  env_name       = "marketing"
  network_id = module.vpc_dev.network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids = [module.vpc_dev.subnet_id]
  instance_name  = "vm-marketing"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    owner   = "team-marketing"
    project = "marketing"
  }

  metadata = {
    user-data          = local.cloudinit
    serial-port-enable = "1"
  }
}
