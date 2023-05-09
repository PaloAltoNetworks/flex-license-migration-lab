location            = "north europe"
resource_group_name = "migration-test"
common_vmseries_sku = "byol"
vm_series_version   = "10.1.9"
username            = "panadmin"
password            = "SecurePassWord12!!"
allow_inbound_mgmt_ips = [
  "0.0.0.0/0", # OR add your own public IP address here, visit "https://ifconfig.me/"
]
firewall1 = "Firewall1"
firewall2 = "Firewall2"

storage_account_name    = "pantfstoragetest"
storage_share_name      = "bootstrapsharetest"

avzones = ["1", "2", "3"]