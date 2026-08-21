# Microsoft BitNet 1-Bit LLM Docker Setup on Windows

This repository provides a self-contained, CPU-first **Linux Docker container setup on Windows Docker Desktop** to run Microsoft's official BitNet 1.58-bit LLM locally and expose an OpenAI-compatible HTTP inference API (`llama-server`).

---

## 1. Architecture Overview

```
Windows Host (Docker Desktop / WSL2)
    │
    ▼ (HTTP :8080)
Official Microsoft MCR Image (mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf)
    ├── Precompiled AVX2 / AVX512 bitnet.cpp kernels
    ├── Bundled BitNet-b1.58-2B-4T model weights
    └── llama-server REST API & Built-in Web UI (:8080)
```

### Key Highlights
- **Zero Local Compilation**: Consumes Microsoft's official prebuilt container image from the Microsoft Container Registry (MCR).
- **CPU-First**: Runs directly on x86_64 CPU instructions using BitNet's lookup table kernels (`i2_s` / `tl2`). No CUDA / GPU required.
- **Model Persistence & Custom Weights**: Default bundled 2B model works out-of-the-box, or mount custom models via `./models:/models`.
- **Strict Host Ollama Isolation**: BitNet exposes port `8080` on the host, leaving host Ollama on `localhost:11434` completely untouched.
- **Built-in Web UI**: Access the interactive chat UI directly in your browser at `http://localhost:8080/`.

---

## 2. Quick Start (Windows PowerShell)

### Step 1: Start the Service (Zero Compilation)
Pull the prebuilt official image and start the server:
```powershell
.\scripts\start.ps1
```
*(Or directly via `docker compose pull && docker compose up -d`)*

### Step 2: Run Smoke Test
Run the automated Python smoke test:
```powershell
.\scripts\test.ps1
```

### Step 3: Open Built-in Web UI
Open `http://localhost:8080/?new_chat=true#/` in your web browser.

### Step 4: Stop the Service
When finished, stop the container:
```powershell
.\scripts\stop.ps1
```

---

## 3. Configuration (`.env`)

You can customize parameters in `.env`:

| Variable | Default | Description |
| :--- | :--- | :--- |
| `BITNET_HOST_PORT` | `8080` | Host port exposed for HTTP requests |
| `BITNET_MODEL` | `/models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf` | Container path to GGUF model |
| `BITNET_THREADS` | `4` | Number of CPU inference worker threads |
| `BITNET_CTX_SIZE` | `2048` | Context window token size |
| `BITNET_TEMP` | `0.7` | Sampling temperature |
| `BITNET_N_PREDICT` | `4096` | Maximum generation length |

---

## 4. API Endpoints & Usage

The container exposes standard OpenAI-compatible REST endpoints:

### List Models
```powershell
curl http://localhost:8080/v1/models
```

### Chat Completion Example
```powershell
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

Invoke-RestMethod -Uri "http://localhost:8080/v1/chat/completions" -Method Post -Body $body -ContentType "application/json"
```

---

## 5. Troubleshooting & FAQ

### Port Conflict on 8080
If port 8080 is occupied by another application, edit `.env`:
```ini
BITNET_HOST_PORT=8090
```
Then restart: `.\scripts\start.ps1`.

### Container Logs
To view runtime inference server logs:
```powershell
docker compose logs -f bitnet
```

### Resource Usage
To inspect real-time CPU and RAM utilization:
```powershell
docker stats bitnet-server
```

### Ollama Independence Notice
> **Note**: Ollama is not required for BitNet and is completely untouched by this project. Host Ollama at `localhost:11434` operates independently.

---

## 6. Windows Portable Setup (No Docker / Low-End Laptops)

For low-end Windows laptops where Docker Desktop is not installed or supported, this repository provides a standalone, portable Windows native distribution.

### Quick Start:
1. Download `bitnet-windows-x64.zip` from GitHub Releases.
2. Extract the archive (e.g. to `C:\bitnet\`).
3. Run `start.bat` (or right-click `start.ps1` -> *Run with PowerShell*).
4. Access `http://localhost:8080/` directly in your browser.

See [`portable/README.md`](file:///F:/Playgrounds/microsoft-bitnet-setup-on-windows-docker/portable/README.md) and [`.github/workflows/build-windows-portable.yml`](file:///F:/Playgrounds/microsoft-bitnet-setup-on-windows-docker/.github/workflows/build-windows-portable.yml) for full packaging and build details.

