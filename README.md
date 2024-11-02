## Criar as imagens principais para genrenciamento

```bash
    cd core
```
```bash
    docker compose up -d
```

### Login padrão do nginx-proxy-manager

Email:    admin@example.com
Password: changeme

Email:    admin@infinite.com
Password: infinite@0303

### Login padrão do Sonatype Nexus Repository

```bash
    docker exec -it sonatype-nexus bash
```

```bash
    cat /nexus-data/admin.password
```

### Login padrão do Jekins

```bash
    docker exec -it jenkins bash
```

```bash
    cat /var/jenkins_home/secrets/initialAdminPassword
```

### Configuração imagens

```bash
    nano install.sh
```

```bash
    chmod +x ./install.sh
```

```bash
    sudo ./install.sh
```
