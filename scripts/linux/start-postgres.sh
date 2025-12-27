set -euo pipefail

cd "$(dirname "$0")/../postgres" || {
  echo "Erro: diretório ../postgres não encontrado"
  exit 1
}

docker-compose -f docker-compose.yml up -d