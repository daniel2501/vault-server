
provider "aws" {
    # profile            = "default"
    region               = "us-east-2"
}


module "base" {
  count                  = (local.tf_vars.run_base ? 1 : 0)
  source                 = "./base"
  public_key_file_name   = local.tf_vars.public_key_file_name
}


module "cluster" {
  depends_on             = [module.base]
  count                  = (local.tf_vars.run_cluster ? 1 : 0)
  source                 = "./cluster"
  key_name               = module.base[0].key_name # (local.tf_vars.run_base ? module.base[0].key_name : "")
  ami_id                 = local.tf_vars.ami_id
  instance_type          = local.tf_vars.instance_type
  security_group_id      = (local.tf_vars.run_base ? module.base[0].security_group_id : "")
  device_name            = local.tf_vars.hdd.device_name
  volume_type            = local.tf_vars.hdd.volume_type
  volume_size            = local.tf_vars.hdd.volume_size_in_gb
  os_username            = local.tf_vars.os_username
  private_key_file_name  = local.tf_vars.private_key_file_name
  domain_name            = local.vs_vars.domain_name
  hostname               = local.vs_vars.hostname
  vault_version          = local.vs_vars.vault_version
  cert_email             = local.vs_vars.cert_email
}


module "eip" {
  count                  = (local.tf_vars.run_eip ? 1 : 0)
  source                 = "./eip"
  instance_id            = (local.tf_vars.run_cluster ? module.cluster[0].instance_id : "")
  associate_instance     = local.tf_vars.associate_instance
}


module "set-up-vault-ubuntu" {
  count                  = (local.tf_vars.run_set_up_vault_ubuntu ? 1 : 0)
  source                 = "./set-up-vault-ubuntu"
  depends_on             = [module.eip, module.cluster]
  os_username            = local.tf_vars.os_username
  private_key_file_name  = local.tf_vars.private_key_file_name
  eip                    = (local.tf_vars.run_eip ? module.eip[0].eip : "")
}
