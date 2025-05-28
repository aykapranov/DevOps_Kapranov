###cloud vars
variable "cloud_id" {
  type        = string
  default     = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = ""
#   description = "ssh-keygen -t ed25519"
# }

### VM 1
variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя ВМ"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Платформа ВМ"
}

# variable "vm_web_cores" {
#   type        = number
#   default     = 2
#   description = "Количество ядер"
# }

# variable "vm_web_memory" {
#   type        = number
#   default     = 1
#   description = "Объём RAM в 10 ГБ"
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   default     = 20
#   description = "Доля CPU"
# }

variable "vm_web_size" {
  type        = number
  default     = 10
  description = "Размер диска"
}

### VM 2 


variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Имя ВМ"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Платформа ВМ"
}

# variable "vm_db_cores" {
#   type        = number
#   default     = 2
#   description = "Количество ядер"
# }

# variable "vm_db_memory" {
#   type        = number
#   default     = 2
#   description = "Объём RAM в 10 ГБ"
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   default     = 20
#   description = "Доля CPU"
# }

variable "vm_db_size" {
  type        = number
  default     = 10
  description = "Размер диска"
}

# Для 5 задания 

variable "project_name" {
  default = "netology"
}

variable "vm_platform_web" {
  default = "platform-web"
}

variable "vm_platform_db" {
  default = "platform-db"
}

# Задание 6

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  }

variable "var_metadata" {
  type        = map(string)
}

  