data "azurerm_subscription" "current" {}

resource "azurerm_monitor_diagnostic_setting" "diag_dev_monitor" {
  name                       = "diag-${random_string.main.id}"
  target_resource_id         = data.azurerm_subscription.current.id
  storage_account_id         = azurerm_storage_account.st_dev_monitor.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_dev_monitor.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "ServiceHealth"
  }

  enabled_log {
    category = "ResourceHealth"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "AutoScale"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Recommendation"
  }
}