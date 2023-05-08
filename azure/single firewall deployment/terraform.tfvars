location            = "north europe"
resource_group_name = "migration-test"
common_vmseries_sku = "byol"
username            = "panadmin"
allow_inbound_mgmt_ips = [
  "0.0.0.0/0", # OR add your own public IP address here, visit "https://ifconfig.me/"
]
firewall1 = "Firewall1"
firewall2 = "Firewall2"

vm_series_version = "10.1.9"

avzones = ["1", "2", "3"]