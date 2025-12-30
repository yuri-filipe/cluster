# Docker Registry com TLS (registry.infinitehome.arpa:8443)

Este tutorial instala um **Docker Registry open source**, leve, com **TLS**, usando:
- Domínio: `registry.infinitehome.arpa`
- Porta: `8443`
- Certificado: self-signed (obrigatório para `.arpa`)

---

## Estrutura

```
/opt/registry
 ├── certs/
 │   ├── domain.crt
 │   └── domain.key
 ├── data/
 └── docker-compose.yml
```

---

## 1. Criar diretórios

```bash
sudo mkdir -p /opt/registry/{certs,data}
cd /opt/registry
```

---

## 2. Gerar certificado TLS

```bash
DOMAIN="registry.infinitehome.arpa"

openssl req -x509 -nodes -days 3650   -newkey rsa:4096   -keyout certs/domain.key   -out certs/domain.crt   -subj "/CN=${DOMAIN}"   -addext "subjectAltName=DNS:${DOMAIN}"
```

---

## 3. docker-compose.yml

Arquivo já incluído neste zip.

---

## 4. Subir o registry

```bash
docker compose up -d
```

Teste:
```bash
curl https://registry.infinitehome.arpa:8443/v2/_catalog
```

---

## 5. Confiar no certificado

### Linux

```bash
sudo mkdir -p /etc/docker/certs.d/registry.infinitehome.arpa:8443
sudo cp certs/domain.crt   /etc/docker/certs.d/registry.infinitehome.arpa:8443/ca.crt

sudo systemctl restart docker
```

### Windows (Docker Desktop)

Copiar `domain.crt` para:

```
C:\ProgramData\Docker\certs.d\registry.infinitehome.arpa:8443\ca.crt
```

Depois:
- Restart Docker Desktop

---

## 6. Teste final

```bash
docker login registry.infinitehome.arpa:8443
docker tag nginx registry.infinitehome.arpa:8443/nginx:latest
docker push registry.infinitehome.arpa:8443/nginx:latest
docker pull registry.infinitehome.arpa:8443/nginx:latest
```

---

## Observações

- `.arpa` não funciona com Let's Encrypt
- Backup = copiar pasta `data`
- Registry não precisa de nginx
- Se der erro x509 → certificado não confiado

Fim. Simples. Funciona.