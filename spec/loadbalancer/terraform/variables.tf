variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_instance_lber" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    tags                        = map(string)
  })
}

variable "aws_instance_gw" {
  type = object({
    count                       = number
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    tags                        = map(string)

    # Watcher properties
    watcher_mod                 = string
    watcher_gpt                 = string
    watcher_zon                 = string
    watcher_grp                 = string
    watcher_sst                 = string
    watcher_dbg                 = string
    watcher_tkn                 = string
    watcher_hst                 = string
    watcher_cps                 = string
    watcher_env                 = string
    watcher_license             = string
    watcher_role                = string
    watcher_devId               = string
    watcher_scope               = string
    watcher_certsDir            = string
    watcher_mode                = string
    watcher_os                  = string
    watcher_arch                = string
    watcher_instance            = string
    watcher_duration            = string
    watcher_cpuPeriod           = string
    watcher_cpuQuota            = string
    watcher_cpuShared           = string
    watcher_inMemory            = string
    watcher_swapMemory          = string
    watcher_oauth2              = string
    watcher_httpPort            = string
    watcher_tcpPort             = string
    watcher_customPort          = string
    watcher_contRev             = string
    watcher_contArtURL          = string
  })
}