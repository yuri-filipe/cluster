#!/bin/bash

# Função para verificar o status do comando
check_status() {
  if [ $? -ne 0 ]; then
    echo "Falha na etapa: $1"
    exit 1
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

# Criar grupo docker
sudo groupadd docker
check_status "Criação do grupo Docker"

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
check_status "Adição do usuário ao grupo Docker"

# Atualizar grupo do usuário
newgrp docker
check_status "Atualização do grupo do usuário"

# Testar instalação do Docker
docker run hello-world
check_status "Teste da instalação do Docker"

echo "Instalação concluída com sucesso!"