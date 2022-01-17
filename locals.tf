
locals  {
  tf_vars = yamldecode(file("${path.root}/vault-config-file.yaml"))["tf_vars"]
  vs_vars = yamldecode(file("${path.root}/vault-config-file.yaml"))["vs_vars"]
}
