locals {
  account_id_base   = trim(replace(lower(var.name), "/[^a-z0-9-]/", "-"), "-")
  account_id_suffix = local.account_id_base != "" ? local.account_id_base : "runtime"
  account_id        = trim(substr("batch-${local.account_id_suffix}", 0, 30), "-")
  roles             = setunion(var.runtime_roles, var.additional_runtime_roles)
}
