resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = local.tags
}

resource "azurerm_subnet" "batch" {
  name                 = local.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefixes
  service_endpoints    = var.service_endpoints
}

resource "azurerm_network_security_group" "batch" {
  count = var.create_network_security_group ? 1 : 0

  name                = local.nsg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "batch" {
  count = var.create_network_security_group ? 1 : 0

  subnet_id                 = azurerm_subnet.batch.id
  network_security_group_id = azurerm_network_security_group.batch[0].id
}

resource "azurerm_public_ip" "nat" {
  count = var.create_nat_gateway ? 1 : 0

  name                = local.nat_public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  name                    = local.nat_gateway_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout_minutes
  tags                    = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = var.create_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "batch" {
  count = var.create_nat_gateway ? 1 : 0

  subnet_id      = azurerm_subnet.batch.id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}
