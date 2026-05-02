#!/bin/sh

CONSUL_HTTP_ADDR="http://consul-server-1:8500"

# Tokens fixos para facilitar o uso no Pipeline e no código.
# Você pode alterá-los aqui se desejar, desde que sejam UUIDs válidos.
MASTER_TOKEN="${CONSUL_MASTER_TOKEN:-}"
FRONTEND_TOKEN="${CONSUL_FRONTEND_TOKEN:-}"
BACKEND_TOKEN="${CONSUL_BACKEND_TOKEN:-}"

echo "Aguardando o Consul Server 1 estar pronto..."
until curl -s "$CONSUL_HTTP_ADDR/v1/status/leader" | grep -q '":'; do
  echo "Aguardando Consul..."
  sleep 2
done

echo "Consul está pronto! Criando políticas e permissões via API..."

# 1. Criar Policy Frontend (Apenas leitura em frontend/)
curl -s --request PUT \
  --header "X-Consul-Token: $MASTER_TOKEN" \
  --data '{"Name": "frontend", "Description": "Acesso de Leitura Frontend", "Rules": "key_prefix \"frontend/\" { policy = \"read\" }"}' \
  "$CONSUL_HTTP_ADDR/v1/acl/policy"

echo -e "\nPolicy Frontend criada."

# 2. Criar Policy Backend (Leitura/Escrita em backend/ e leitura em frontend/)
curl -s --request PUT \
  --header "X-Consul-Token: $MASTER_TOKEN" \
  --data '{"Name": "backend", "Description": "Acesso Completo Backend", "Rules": "key_prefix \"backend/\" { policy = \"write\" }\nkey_prefix \"frontend/\" { policy = \"read\" }"}' \
  "$CONSUL_HTTP_ADDR/v1/acl/policy"

echo -e "\nPolicy Backend criada."

# 3. Criar Token Frontend
curl -s --request PUT \
  --header "X-Consul-Token: $MASTER_TOKEN" \
  --data "{\"Description\": \"Token do Frontend\", \"Policies\": [{\"Name\": \"frontend\"}], \"SecretID\": \"$FRONTEND_TOKEN\"}" \
  "$CONSUL_HTTP_ADDR/v1/acl/token"

echo -e "\nToken Frontend configurado: $FRONTEND_TOKEN"

# 4. Criar Token Backend
curl -s --request PUT \
  --header "X-Consul-Token: $MASTER_TOKEN" \
  --data "{\"Description\": \"Token do Backend\", \"Policies\": [{\"Name\": \"backend\"}], \"SecretID\": \"$BACKEND_TOKEN\"}" \
  "$CONSUL_HTTP_ADDR/v1/acl/token"

echo -e "\nToken Backend configurado: $BACKEND_TOKEN"

echo -e "\nSetup de permissoes concluido com sucesso!"
