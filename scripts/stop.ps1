<#
.SYNOPSIS
Stops the BitNet Docker container.
#>
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Stopping BitNet Service" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

docker compose down

Write-Host "[OK] BitNet container stopped." -ForegroundColor Green
