# Resource group to hold all the resources.
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}
#test
# Generate a random password for VM-Series.
resource "random_password" "this" {
  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "_%@"
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

# The VM-Series virtual machine
module "vmseries1" {
  source = "../modules/vmseries"

  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.firewall1
  username            = var.username
  password            = random_password.this.result
  img_sku             = var.common_vmseries_sku
  img_version         = var.vm_series_version
  avzones             = var.avzones
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
  password            = random_password.this.result
  img_sku             = var.common_vmseries_sku
  img_version         = var.vm_series_version
  avzones             = var.avzones
  interfaces = [
    {
      name             = "myfw-mgmt"
      subnet_id        = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip = true
    },
  ]
}