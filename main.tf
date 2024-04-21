resource "random_string" "main" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg_dev_monitor" {
  name     = "rg-dev-monitor-${random_string.main.id}"
  location = var.rg_location

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_storage_account" "st_dev_monitor" {
  name                     = "st${random_string.main.id}"
  resource_group_name      = azurerm_resource_group.rg_dev_monitor.name
  location                 = azurerm_resource_group.rg_dev_monitor.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_log_analytics_workspace" "log_dev_monitor" {
  name                = "log-dev-monitor-${random_string.main.id}"
  location            = azurerm_resource_group.rg_dev_monitor.location
  resource_group_name = azurerm_resource_group.rg_dev_monitor.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "Dev"
  }
}
