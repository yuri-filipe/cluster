acl {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    initial_management = "",
    agent =
  }
}

# Caso não esteja usando o middleware de CORS do Traefik e os frontends
# estiverem acessando pela porta 8500 diretamente, descomente o bloco abaixo:
# http_config {
#   response_headers {
#     "Access-Control-Allow-Origin" = "*"
#     "Access-Control-Allow-Methods" = "GET, OPTIONS"
#     "Access-Control-Allow-Headers" = "X-Consul-Token, Content-Type"
#   }
# }