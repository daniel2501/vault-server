ui            = true
disable_cache = true
disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/etc/letsencrypt/live/vault-test.tk/fullchain.pem"
  tls_key_file  = "/etc/letsencrypt/live/vault-test.tk/privkey.pem"
}

storage "file" {
  path = "/var/lib/vault"
}
