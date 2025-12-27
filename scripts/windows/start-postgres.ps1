$ErrorActionPreference = 'Stop'

$scriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$postgresDir  = Join-Path    $scriptDir '..\..\apps\postgres'

if (-not (Test-Path $postgresDir -PathType Container)) {
    Write-Error "Erro: diretório '$postgresDir' não encontrado"
    exit 1
}

# Verifica se a network 'network_proxy' existe
$networkExists = docker network ls --format '{{.Name}}' | Select-String -Pattern '^network_proxy$'

if (-not $networkExists) {
    & "$scriptDir\create-network.ps1"
}

Set-Location $postgresDir
docker-compose -f docker-compose.yml up -d
