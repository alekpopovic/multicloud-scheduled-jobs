locals {
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "azure-batch-account-pool"
  })

  safe_name      = trim(replace(lower(var.name), "/[^a-z0-9-]/", "-"), "-")
  alnum_name     = replace(lower(var.name), "/[^a-z0-9]/", "")
  alnum_fallback = local.alnum_name != "" ? local.alnum_name : "batch"

  storage_account_name = var.storage_account_name != null ? var.storage_account_name : substr("${substr(local.alnum_fallback, 0, 18)}${random_string.suffix.result}", 0, 24)
  batch_account_name   = var.batch_account_name != null ? var.batch_account_name : substr("${substr(local.alnum_fallback, 0, 18)}${random_string.suffix.result}", 0, 24)
  pool_name            = var.pool_name != null ? var.pool_name : substr("${local.safe_name}-pool", 0, 64)

  acr_name         = var.acr_id != null ? element(reverse(split("/", var.acr_id)), 0) : null
  acr_login_server = local.acr_name != null ? "${local.acr_name}.azurecr.io" : null
}
