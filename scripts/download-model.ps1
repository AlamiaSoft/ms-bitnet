<#
.SYNOPSIS
Downloads the official Microsoft BitNet 1-bit LLM weights.
#>
param(
    [string]$ModelRepo = "microsoft/bitnet-b1.58-2B-4T-gguf",
    [string]$TargetDir = "models/BitNet-b1.58-2B-4T",
    [string]$ModelFile = "ggml-model-i2_s.gguf"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " BitNet Model Downloader" -ForegroundColor Cyan
Write-Host " Model: $ModelRepo" -ForegroundColor Cyan
Write-Host " Target Directory: $TargetDir" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
}

$destFilePath = Join-Path $TargetDir $ModelFile

if ((Test-Path $destFilePath) -and ((Get-Item $destFilePath).Length -gt 1000000000)) {
    $sizeMB = [math]::Round((Get-Item $destFilePath).Length / 1MB, 2)
    Write-Host "[OK] Model file already exists at: $destFilePath ($sizeMB MB)" -ForegroundColor Green
    exit 0
}

$directUrl = "https://huggingface.co/$ModelRepo/resolve/main/$ModelFile"
Write-Host "Downloading model from $directUrl..." -ForegroundColor Yellow
Write-Host "Saving to $destFilePath (approx. 1.18 GB)..." -ForegroundColor Yellow

$curlCmd = Get-Command "curl.exe" -ErrorAction SilentlyContinue
if ($curlCmd) {
    & curl.exe -L -o "$destFilePath" "$directUrl" --progress-bar
} else {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($directUrl, $destFilePath)
}

if ((Test-Path $destFilePath) -and ((Get-Item $destFilePath).Length -gt 1000000000)) {
    $sizeMB = [math]::Round((Get-Item $destFilePath).Length / 1MB, 2)
    Write-Host "[OK] Download completed successfully: $destFilePath ($sizeMB MB)" -ForegroundColor Green
} else {
    Write-Error "Failed to verify downloaded model file at $destFilePath"
}
