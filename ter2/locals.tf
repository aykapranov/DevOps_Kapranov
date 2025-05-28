locals {

  vm_names = {
    web = "${var.project_name}-${var.vpc_name}-${var.vm_platform_web}"
    db  = "${var.project_name}-${var.vpc_name}-${var.vm_platform_db}"
  }
}