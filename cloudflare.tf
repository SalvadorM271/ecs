//cloudflare

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_record" "record" {
  zone_id = var.domain_id
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = true
  ttl = 1
}