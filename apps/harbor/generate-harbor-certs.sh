#!/usr/bin/env bash
set -euo pipefail

HARBOR_HOST="harbor.infinitehome.arpa"
HARBOR_IP="10.66.66.2"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${BASE_DIR}/out"
CERT_DIR="/data/cert"

mkdir -p "${OUT_DIR}"
cd "${OUT_DIR}"

echo "==> Gerando CA..."
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
  -subj "/C=BR/ST=SP/L=SP/O=InfiniteHome/OU=Harbor/CN=${HARBOR_HOST} Root CA" \
  -key ca.key -out ca.crt

echo "==> Gerando chave e CSR do servidor..."
openssl genrsa -out "${HARBOR_HOST}.key" 4096
openssl req -sha512 -new \
  -subj "/C=BR/ST=SP/L=SP/O=InfiniteHome/OU=Harbor/CN=${HARBOR_HOST}" \
  -key "${HARBOR_HOST}.key" -out "${HARBOR_HOST}.csr"

echo "==> Gerando arquivo de extensões (SAN DNS + IP)..."
cat > v3.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${HARBOR_HOST}
DNS.2=localhost
IP.1=${HARBOR_IP}
IP.2=127.0.0.1
EOF

echo "==> Assinando certificado do servidor com o CA..."
openssl x509 -req -sha512 -days 3650 -extfile v3.ext \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -in "${HARBOR_HOST}.csr" -out "${HARBOR_HOST}.crt"

echo "==> Instalando certificado e chave no caminho do Harbor: ${CERT_DIR}"
sudo mkdir -p "${CERT_DIR}"
sudo cp "${HARBOR_HOST}.crt" "${CERT_DIR}/"
sudo cp "${HARBOR_HOST}.key" "${CERT_DIR}/"

echo
echo "OK."
echo "Arquivos gerados em: ${OUT_DIR}"
echo "Cert do servidor: ${OUT_DIR}/${HARBOR_HOST}.crt"
echo "Key do servidor:  ${OUT_DIR}/${HARBOR_HOST}.key"
echo "CA (para confiar nos clientes): ${OUT_DIR}/ca.crt"
