<#
.SYNOPSIS
Starts the BitNet Docker container and waits for the health endpoint.
#>
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Starting BitNet Inference Service" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Start container
docker compose up -d

# 3. Read configured port
$port = "8080"
if (Test-Path ".env") {
    $envContent = Get-Content ".env" | Where-Object { $_ -match "^BITNET_HOST_PORT=(\d+)" }
    if ($envContent) {
        $port = ($envContent -split "=")[1].Trim()
    }
}

Write-Host "Waiting for BitNet llama-server to be ready at http://localhost:$port/v1/models..." -ForegroundColor Yellow

$maxAttempts = 30
$attempt = 0
$ready = $false

while ($attempt -lt $maxAttempts) {
    Start-Sleep -Seconds 2
    $attempt++
    try {
        $resp = Invoke-RestMethod -Uri "http://localhost:$port/v1/models" -Method Get -TimeoutSec 2 -ErrorAction Stop
        if ($resp -and $resp.data) {
            $ready = $true
            break
        }
    } catch {
        Write-Host "  Attempt $attempt of $maxAttempts - waiting for server startup..." -ForegroundColor Gray
    }
}

if ($ready) {
    Write-Host "[OK] BitNet inference service is READY at http://localhost:$port" -ForegroundColor Green
    Write-Host "You can test the service using: .\scripts\test.ps1" -ForegroundColor Cyan
} else {
    Write-Host "[WARNING] Service did not respond within expected timeout. Checking logs:" -ForegroundColor Red
    docker compose logs --tail 20
}
