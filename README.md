## Criar as imagens principais para genrenciamento

```bash
    cd core
```
```bash
    docker compose up -d
```

### Login padrão do postgres

Login:    postgres
Password:

### Login padrão do nginx-proxy-manager

Email:    admin@example.com
Password: changeme

Email:    admin@infinite.com
Password:

### Login padrão do Sonatype Nexus Repository

```bash
    docker exec -it core-sonatype-nexus3-1 bash
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

