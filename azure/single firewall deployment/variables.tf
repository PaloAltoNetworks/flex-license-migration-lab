variable "location" {
  description = "The Azure region to use."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create."
  type        = string
}

variable "username" {
  description = "Initial administrative username. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm)."
  type        = string
}

variable "password" {
  description = "Initial administrative username. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm)."
  type        = string
}

variable "storage_account_name" {
  description = <<-EOF
  Default name of the storage account to create.
  The name you choose must be unique across Azure. The name also must be between 3 and 24 characters in length, and may include only numbers and lowercase letters.
  EOF
  default     = "pantfstorage"
  type        = string
}

variable "files" {
  description = "Map of all files to copy to bucket. The keys are local paths, the values are remote paths. Always use slash `/` as directory separator (unix-like), not the backslash `\\`. For example `{\"dir/my.txt\" = \"config/init-cfg.txt\"}`"
  default     = {}
  type        = map(string)
}

variable "storage_share_name" {
  description = "Name of storage share to be created that holds `files` for bootstrapping."
  type        = string
}


variable "allow_inbound_mgmt_ips" {
  description = <<-EOF
    List of IP CIDR ranges (like `["23.23.23.23"]`) that are allowed to access management interfaces of VM-Series.
    If you use Panorama, include its address in the list (as well as the secondary Panorama's).
  EOF
  type        = list(string)
}

variable "common_vmseries_sku" {
  description = "VM-Series SKU, for example `bundle1`, or `bundle2`. If it is `byol`, the VM-Series starts unlicensed."
  type        = string
}

variable "vm_series_version_set1" {
  description = "VMSeries PanOS Version"
  default     = "10.1.0"
  type        = string
}

variable "vm_series_version_set2" {
  description = "VMSeries PanOS Version"
  default     = "10.1.0"
  type        = string
}

variable "vm_series_version_set3" {
  description = "VMSeries PanOS Version"
  default     = "10.1.0"
  type        = string
}

variable "avzones" {
  description = <<-EOF
  After provider version 3.x you need to specify in which availability zone(s) you want to place IP.
  ie: for zone-redundant with 3 availability zone in current region value will be:
  ```["1","2","3"]```
  Use command ```az vm list-skus --location REGION_NAME --zone --query '[0].locationInfo[0].zones'``` to see how many AZ is
  in current region.
  EOF
  default     = []
  type        = list(string)
}

variable "firewall1" {
  default = "Firewall1"
}
variable "firewall2" {
  default = "Firewall2"
}
variable "firewall3" {
  default = "Firewall3"
}
variable "firewall4" {
  default = "Firewall4"
}
variable "firewall5" {
  default = "Firewall5"
}
variable "firewall6" {
  default = "Firewall6"
}

variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}