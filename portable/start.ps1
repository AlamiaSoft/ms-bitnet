<#
.SYNOPSIS
Portable BitNet Server Launcher for Windows (Zero Docker Required).
#>
$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Starting BitNet Portable Server (Windows Native / No Docker)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$port = 8080
$threads = [Math]::Max(1, [Environment]::ProcessorCount - 2)
$modelPath = "models\ggml-model-i2_s.gguf"
$exePath = "bin\llama-server.exe"

# 1. Verify executable exists
if (-not (Test-Path $exePath)) {
    Write-Host "[ERROR] Binary not found at $exePath" -ForegroundColor Red
    Write-Host "Please ensure the zip file was completely extracted with the 'bin' folder." -ForegroundColor Yellow
    exit 1
}

# 2. Check and auto-download model file if missing
if (-not (Test-Path $modelPath)) {
    Write-Host "[INFO] Model weights not found at $modelPath" -ForegroundColor Yellow
    if (-not (Test-Path "models")) { New-Item -ItemType Directory -Path "models" | Out-Null }
    $url = "https://huggingface.co/microsoft/BitNet-b1.58-2B-4T-gguf/resolve/main/ggml-model-i2_s.gguf"
    Write-Host "Automatically downloading 'ggml-model-i2_s.gguf' (~1.2 GB) from Hugging Face..." -ForegroundColor Cyan
    Write-Host "URL: $url" -ForegroundColor Gray
    Start-BitsTransfer -Source $url -Destination $modelPath -DisplayName "BitNet Model Download"
    Write-Host "[OK] Download completed successfully!" -ForegroundColor Green
}

Write-Host "Starting llama-server on http://localhost:$port (Threads: $threads) ..." -ForegroundColor Green
Write-Host "OpenAI API: http://localhost:$port/v1" -ForegroundColor Cyan
Write-Host "Web UI:     http://localhost:$port/?new_chat=true#/" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to terminate the server." -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Cyan

& $exePath `
    -m $modelPath `
    --host 0.0.0.0 `
    --port $port `
    -t $threads `
    --repeat-penalty 1.15 `
    --repeat-last-n 64 `
    --top-p 0.9 `
    --min-p 0.05 `
    --temp 0.7
