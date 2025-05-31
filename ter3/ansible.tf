locals {
  web_instances = [
    for vm in yandex_compute_instance.web : {
      name         = vm.name
      ip           = vm.network_interface[0].nat_ip_address
      fqdn         = vm.fqdn
    }
  ]

  db_instances = [
    for _, vm in yandex_compute_instance.db_vm : {
      name         = vm.name
      ip           = vm.network_interface[0].nat_ip_address
      fqdn         = vm.fqdn
    }
  ]

  storage_instance = {
    name = yandex_compute_instance.storage.name
    ip   = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    fqdn = yandex_compute_instance.storage.fqdn
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    web_instances     = local.web_instances
    db_instances      = local.db_instances
    storage_instance  = local.storage_instance
  })

  filename = "${abspath(path.module)}/hosts.ini"
}
