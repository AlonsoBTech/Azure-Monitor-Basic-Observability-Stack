## Azure Monitor Basic Observability Stack

## 📋 <a name="table">Table of Contents</a>

1. 🤖 [Introduction](#introduction)
2. ⚙️ [Prerequisites](#prerequisites)
3. 🔋 [What Is Being Created](#what-is-being-created)
4. 🤸 [Quick Guide](#quick-guide)
5. 🔗 [Links](#links)

## <a name="introduction">🤖 Introduction</a>

Here we are creating a basic observability stack using Storage Account and Log Analytic Workspace. 
Using Azure Monitor, we set up a diagnostic settings to send our Subscription logs to the created
storage account.

## <a name="prerequisites">⚙️ Prerequisites</a>

Make sure you have the following:

- Azure Account
- Terraform Installed
- IDE of Choice to write Terraform Code

## <a name="what-is-being-created">🔋 What Is Being Created</a>

What we will be using and creating:

- Resource Group
- Storage Account
- Log Analytic Workspace
- Azure Monitor

## <a name="quick-guide">🤸 Quick Guide</a>

**First create your git repository (name it whatever you like) then clone the git repository**

```bash
git clone https://github.com/AlonsoBTech/Azure-Basic-Observability-Stack.git
cd Azure-Basic-Observability-Stack
```

**Create your Terraform folder**
```bash
mkdir Terraform
cd Terraform
```

**Create your Terraform providers.tf file**

</details>

<details>
<summary><code>providers.tf</code></summary>

```bash
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.100.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

provider "azurerm" {
  features {}
}
```
</details>

**Create your Terraform main.tf file**

</details>

<details>
<summary><code>main.tf</code></summary>

```bash
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
```

</details>

**Create your monitor.tf file**

</details>

<details>
<summary><code>monitor.tf</code></summary>

```bash
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
```

</details>

**Create your variables.tf file**

</details>

<details>
<summary><code>variables.tf</code></summary>

  ```bash
variable "rg_location" {
  type    = string
  default = "canadacentral"
}
```

</details>

**Create your .gitignore file**

</details>

<details>
<summary><code>.gitignore</code></summary>

```bash
.terraform
.terraform.*
*.tfstate
*.tfstate.*
```

</details>

**Check your Azure console to ensure resources were created**

Resource Group created with Stoarge Account and Log Analytics Worksapce

![rg-panel](https://github.com/AlonsoBTech/Azure-Monitor-Basic-Observability-Stack/assets/160416175/e17195bc-4102-41c7-9496-e251bedde7e2)

## <a name="links">🔗 Links</a>

- [Terraform Azure Provider Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
