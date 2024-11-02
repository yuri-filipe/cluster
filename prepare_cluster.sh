#!/bin/bash

# Códigos de cor ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sem cor

# Definir a variável CLUSTER_REPOSITORY
CLUSTER_REPOSITORY="https://github.com/yuri-filipe/cluster.git"

# Função para verificar o status do comando
check_status() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}Falha na etapa: $1${NC}"
    exit 1
  else
    echo -e "${GREEN}Etapa concluída: $1${NC}"
  fi
}

# Atualizar lista de pacotes
sudo apt-get update
check_status "Atualização da lista de pacotes"

# Atualizar pacotes instalados
sudo apt-get upgrade -y
check_status "Atualização dos pacotes instalados"

# Instalar git
sudo apt-get install -y git
check_status "Instalação do Git"

# Instalar ca-certificates e curl
sudo apt-get install -y ca-certificates curl
check_status "Instalação do ca-certificates e curl"

# Criar diretório para chave GPG
sudo install -m 0755 -d /etc/apt/keyrings
check_status "Criação do diretório para chave GPG"

# Baixar chave GPG do Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
check_status "Download da chave GPG do Docker"

# Ajustar permissões da chave GPG
sudo chmod a+r /etc/apt/keyrings/docker.asc
check_status "Ajuste das permissões da chave GPG"

# Adicionar repositório Docker ao sources.list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_status "Adição do repositório Docker ao sources.list"

# Atualizar lista de pacotes novamente
sudo apt-get update
check_status "Atualização da lista de pacotes após adição do Docker"

# Instalar Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_status "Instalação do Docker"

# Verificar se o grupo docker já existe
if getent group docker > /dev/null 2>&1; then
  echo -e "${GREEN}O grupo Docker já existe.${NC}"
else
  sudo groupadd docker
  if [ $? -ne 0 ]; then
    echo -e "${RED}Falha na etapa: Criação do grupo Docker${NC}"
    exit 1
  else
    echo -e "${GREEN}Etapa concluída: Criação do grupo Docker${NC}"
  fi
fi

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
check_status "Adição do usuário ao grupo Docker"

# Atualizar grupo do usuário
newgrp docker
check_status "Atualização do grupo do usuário"

# Testar instalação do Docker
docker run hello-world
check_status "Teste da instalação do Docker"

# Baixar repositório do cluster
git clone "$CLUSTER_REPOSITORY"
check_status "Baixar repositório do cluster"

cd cluster
check_status "Entrar no diretório do repositório do cluster"

echo -e "${GREEN}Instalação concluída com sucesso!${NC}"