location                  = "north europe"
resource_group_name       = "migration-[Studenname]" #replace [Studentname] with your Name
common_vmseries_sku       = "byol"
vm_series_version_set1    = "9.1.13"
vm_series_version_set2    = "10.0.9"
vm_series_version_set3    = "10.2.3"
username                  = "panadmin"
password                  = "SecurePassWord12!!" #change the password. Use a complex password
allow_inbound_mgmt_ips = [
  "0.0.0.0/0",
]
firewall1 = "Firewall1"
firewall2 = "Firewall2"
firewall3 = "Firewall3"
firewall4 = "Firewall4"
firewall5 = "Firewall5"
firewall6 = "Firewall6"

storage_account_name    = "pantfstorage[Studenname]" #replace [Studentname] with your name in small letters without space
storage_share_name      = "bootstrapshare[Studenname]" #replace [Studentname] with your name in small letters without space

avzones = ["1", "2", "3"]

files = {
  "files/authcodes"    = "license/authcodes"
  "files/init-cfg.txt" = "config/init-cfg.txt"
}