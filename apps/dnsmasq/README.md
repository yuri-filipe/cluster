# DNS Local com Docker + WireGuard

## Estrutura
dnsmasq-wireguard/
├─ docker-compose.yml
└─ conf/
   └─ dnsmasq.conf

## Subir o DNS
docker compose up -d

## WireGuard (cliente)
No arquivo wg-client.conf:

[Interface]
Address = 10.8.0.10/32
DNS = 10.8.0.1

## Testes
nslookup api.home.arpa
ping api.home.arpa

## Observações
- Use domínio home.arpa
- DNS aponta para IP da VPN
- Porta 53 UDP/TCP deve estar liberada
