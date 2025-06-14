variable "network_name" {
  description = "Название VPC сети"
  type        = string
}

variable "subnet_name" {
  description = "Название подсети"
  type        = string
}

variable "zone" {
  description = "Зона подсети"
  type        = string
}

variable "v4_cidr_blocks" {
  description = "CIDR блоки для подсети"
  type        = list(string)
}
