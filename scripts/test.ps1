<#
.SYNOPSIS
Runs inference smoke test against local BitNet container.
#>
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Running BitNet Inference Smoke Test" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$pythonCmd = Get-Command "python" -ErrorAction SilentlyContinue
if ($pythonCmd) {
    & python tests/smoke_test.py
} else {
    Write-Host "Python not found on host path. Running test via curl/PowerShell request..." -ForegroundColor Yellow
    $body = @{
        model = "BitNet-b1.58-2B-4T"
        messages = @(
            @{
                role = "user"
                content = "Explain what a multi-tenant SaaS application is in two sentences."
            }
        )
        temperature = 0.2
    } | ConvertTo-Json -Depth 5

    $start = Get-Date
    $response = Invoke-RestMethod -Uri "http://localhost:8080/v1/chat/completions" -Method Post -Body $body -ContentType "application/json"
    $duration = (Get-Date) - $start

    Write-Host "Response received in $($duration.TotalSeconds)s:" -ForegroundColor Green
    Write-Host $response.choices[0].message.content -ForegroundColor White
}
