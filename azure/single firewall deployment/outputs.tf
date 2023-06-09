output "username" {
  description = "Initial administrative username to use for VM-Series."
  value       = var.username
}

output "mgmt_ip_addresses1" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries1.mgmt_ip_address
}

output "mgmt_ip_addresses2" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries2.mgmt_ip_address
}

output "mgmt_ip_addresses3" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries3.mgmt_ip_address
}

output "mgmt_ip_addresses4" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries4.mgmt_ip_address
}

output "mgmt_ip_addresses5" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries5.mgmt_ip_address
}

output "mgmt_ip_addresses6" {
  description = "IP Addresses for VM-Series management (https or ssh)."
  value       = module.vmseries6.mgmt_ip_address
}