output "secret" {
  value = {
    text   = module.secret__text
    kv     = module.secret__kv
    binary = module.secret__binary
  }
  sensitive = true
}
