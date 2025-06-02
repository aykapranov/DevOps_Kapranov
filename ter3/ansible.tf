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

  storage_instances = [
    for vm in [yandex_compute_instance.storage] : {
      name = vm.name
      ip   = vm.network_interface[0].nat_ip_address
      fqdn = vm.fqdn
    }
  ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    web_instances     = local.web_instances
    db_instances      = local.db_instances
    storage_instances = local.storage_instances
  })

  filename = "${abspath(path.module)}/hosts.ini"
}