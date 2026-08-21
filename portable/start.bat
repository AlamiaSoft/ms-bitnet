@echo off
setlocal enabledelayedexpansion

title BitNet Local Server (Portable)

echo ============================================================
echo  Starting Microsoft BitNet Portable Server (No Docker)
echo ============================================================

set PORT=8080
set THREADS=4
set MODEL=models\ggml-model-i2_s.gguf

if not exist "%MODEL%" (
    echo.
    echo [ERROR] Model weights not found at %MODEL%
    echo.
    echo Please place 'ggml-model-i2_s.gguf' inside the 'models' folder.
    echo You can download it from Hugging Face:
    echo https://huggingface.co/microsoft/BitNet-b1.58-2B-4T-gguf
    echo.
    pause
    exit /b 1
)

echo - Port:        http://localhost:%PORT%
echo - Model:       %MODEL%
echo - Threads:     %THREADS%
echo - Web UI:      http://localhost:%PORT%/?new_chat=true#/
echo.
echo Starting server... Press Ctrl+C to stop.
echo ============================================================

bin\llama-server.exe -m "%MODEL%" --host 0.0.0.0 --port %PORT% -t %THREADS% --repeat-penalty 1.15 --repeat-last-n 64 --top-p 0.9 --min-p 0.05 --temp 0.7

pause
