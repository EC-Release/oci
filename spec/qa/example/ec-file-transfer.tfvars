aws_profile = ""
aws_region  = ""

aws-dc-sandbox-vpc-ec-gw-server-vm = {
  "ami"                         = ""
  "instance_type"               = ""
  "subnet_id"                   = ""
  "security_groups"             = [""]
  "key_name"                    = ""
  "iam_instance_profile"        = ""
  "associate_public_ip_address" = true
  "ec-sftp-user-name"           = ""
  "ec-sftp-user-secret"         = ""
  "ec_gwserver_mod"             = "gw:server"
  "ec_gwserver_zon"             = ""
  "ec_gwserver_sst"             = ""
  "ec_gwserver_hst"             = ""
  "ec_gwserver_aid"             = ""
  "ec_gwserver_grp"             = ""
  "ec_gwserver_cid"             = ""
  "ec_gwserver_csc"             = ""
  "ec_gwserver_dur"             = 1200
  "ec_gwserver_oa2"             = ""
  "ec_gwserver_rht"             = "localhost"
  "ec_gwserver_rpt"             = 22
  "ec_gwserver_gpt"             = 80
  "ec_gwserver_tkn"             = ""
  "ec_gwserver_dbg"             = true

  tags = {
    Name           = "EC-File-Transfer"
    Env            = "Lab"
    Engineer_Email = ""
    Engineer_SSO   = ""
    Best_By        = ""
    UAI            = ""
    Builder        = "Terraform"
  }
}

azure-corp-ec-ft-nic = {
  name                = ""
  location            = ""
  resource_group_name = ""

  ip_configuration = {
    name                          = ""
    subnet_id                     = ""
    private_ip_address_allocation = "Dynamic"
  }
}

azure-corp-ec-vm = {
  name                              = "ec-file-transfer-vm"
  location                          = ""
  resource_group_name               = ""
  vm_size                           = ""
  network_interface_ids             = []
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  ecconfig_mod                      = "client"
  ecconfig_aid                      = ""
  ecconfig_tid                      = ""
  ecconfig_grp                      = ""
  ecconfig_cid                      = ""
  ecconfig_csc                      = ""
  ecconfig_dur                      = 1200
  ecconfig_oa2                      = ""
  ecconfig_hst                      = ""
  ecconfig_lpt                      = 

  storage_image_reference = {
    publisher           = ""
    offer               = ""
    sku                 = ""
    version             = "latest"
  }
  storage_os_disk = {
    name                = ""
    caching             = "ReadWrite"
    create_option       = "FromImage"
    managed_disk_type   = "Standard_LRS"
  }
  os_profile = {
    computer_name       = ""
    admin_username      = ""
    admin_password      = ""
  }
  os_profile_linux_config = {
    disable_password_authentication = false
  }

  tags = {
    Name           = "EC-File-Transfer"
    Env            = "Lab"
    Engineer_Email = ""
    Engineer_SSO   = ""
    Best_By        = ""
    UAI            = ""
    Builder        = "Terraform"
  }
}