# Resource group to hold all the resources.
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network and its Network Security Group
module "vnet" {
  source = "../modules/vnet"

  virtual_network_name = "vnet-vmseries"
  location             = var.location
  resource_group_name  = azurerm_resource_group.this.name
  address_space        = ["192.168.100.0/24"]
  network_security_groups = {
    "management-security-group" = {
      rules = {
        "vm-management-rules" = {
          access                     = "Allow"
          direction                  = "Inbound"
          priority                   = 100
          protocol                   = "Tcp"
          source_port_range          = "*"
          source_address_prefixes    = var.allow_inbound_mgmt_ips
          destination_address_prefix = "*"
          destination_port_range     = "*"
        }
      }
    }
  }
  route_tables = {}
  subnets = {
    "subnet-mgmt" = {
      address_prefixes       = ["192.168.100.0/25"]
      network_security_group = "management-security-group"
    }
  }
}

# The storage account for VM-Series initialization.
module "bootstrap" {
  source = "../modules/bootstrap"

  location             = var.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_name = var.storage_account_name
  storage_share_name   = var.storage_share_name
  files                = var.files
}

# The VM-Series virtual machine
module "vmseries1" {
  source = "../modules/vmseries"

  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.firewall1
  username            = var.username
  password            = var.password
  img_sku             = var.common_vmseries_sku
  img_version         = var.vm_series_version
  avzones             = var.avzones
  bootstrap_options = join(",",
    [
      "storage-account=${module.bootstrap.storage_account.name}",
      "access-key=${module.bootstrap.storage_account.primary_access_key}",
      "file-share=${module.bootstrap.storage_share.name}",
      "share-directory=None"
  ])
  interfaces = [
    {
      name             = "myfw-mgmt"
      subnet_id        = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip = true
    },
  ]
}

module "vmseries2" {
  source = "../modules/vmseries"

  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.firewall2
  username            = var.username
  password            = var.password
  img_sku             = var.common_vmseries_sku
  img_version         = var.vm_series_version
  avzones             = var.avzones
  bootstrap_options = join(",",
    [
      "storage-account=${module.bootstrap.storage_account.name}",
      "access-key=${module.bootstrap.storage_account.primary_access_key}",
      "file-share=${module.bootstrap.storage_share.name}",
      "share-directory=None"
  ])
  interfaces = [
    {
      name             = "myfw-mgmt"
      subnet_id        = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip = true
    },
  ]
}
