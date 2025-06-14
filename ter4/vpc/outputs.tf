output "subnet" {
  description = "Ресурс yandex_vpc_subnet"
  value       = yandex_vpc_subnet.this
}

output "network_id" {
  description = "ID созданной VPC-сети"
  value       = yandex_vpc_network.this.id
}

output "subnet_id" {
  description = "ID созданной подсети"
  value       = yandex_vpc_subnet.this.id
}
