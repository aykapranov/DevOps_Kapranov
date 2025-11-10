# VPC
resource "yandex_vpc_network" "vpc" {
  name = "main-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name = "public"
  zone = var.default_zone
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_kms_symmetric_key" "bucket_key" {
  name = "bucket-key"
  description = "test"
  default_algorithm = "AES_128"
  rotation_period = "8760h"
  deletion_protection = false
}


resource "yandex_storage_bucket" "my_bucket" {
  bucket = var.bucket_name
  folder_id = var.folder_id

  # Шифрование через KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_bucket_grant" "public_read" {
  bucket = yandex_storage_bucket.my_bucket.bucket

  grant {
    type = "Group"
    uri = "http://acs.amazonaws.com/groups/global/AllUsers"
    permissions = ["READ"]
  }
}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.my_bucket.bucket
  key = "picture.png"
  source = "${path.module}/picture.png"
}