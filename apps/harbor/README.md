## Criar as imagens principais para genrenciamento

```bash
    chmod +x ./generate-harbor-certs.sh
```
```bash
    ./generate-harbor-certs.sh
```

### Confere se ficou:

```bash
    ls -lah /data/cert/
```
## Pós-passos obrigatórios (senão vai falhar no docker login)

## Confiança do CA nos clientes (Windows / Docker Desktop):
## Importe out/ca.crt como Trusted Root CA no Windows e reinicie o Docker Desktop.

## DNS:
## Garanta que harbor.infinitehome.arpa resolve para 10.66.66.2 (seu DNS local já faz isso, perfeito).

```bash
    cat /nexus-data/admin.password
```

### Suba o Harbor

```bash
    sudo ./install.sh --with-trivy
```