vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}


var_metadata = {
  serial-port-enable = "1"
  ssh-keys           = ""
}