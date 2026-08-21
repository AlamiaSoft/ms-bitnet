# Sprint 0: Microsoft BitNet 1-Bit LLM Dockerization PoC

## Current Focus
Establishing a local, containerized proof-of-concept for Microsoft BitNet 1.58-bit LLM on Windows Docker Desktop (WSL2), exposing an OpenAI-compatible HTTP inference API.

## Sprint Objectives
1. **Container Runtime**: Multi-stage Linux Docker build targeting BitNet `llama-server` on CPU (x86_64).
2. **Model Serving**: Support official `BitNet-b1.58-2B-4T` (or `bitnet_b1_58-large` / `bitnet_b1_58-3B`) in GGUF format (`i2_s` / `tl2`).
3. **Storage & Persistence**: Bind-mount `./models` directory to `/models` to preserve weights across container restarts.
4. **Developer Workflows**: Complete PowerShell automation scripts (`build.ps1`, `start.ps1`, `stop.ps1`, `test.ps1`, `download-model.ps1`).
5. **Validation & Isolation**: Python smoke-test client (`tests/smoke_test.py`) verifying latency, token generation rate, and complete isolation from host Ollama (`:11434`).

## Active Invariants
- Host Ollama on `:11434` must remain untouched.
- CPU-first execution only (no mandatory CUDA dependencies for PoC).
- Do not create custom gateway abstraction layers yet.

## Acceptance Criteria Tracker
- [x] Docker image builds cleanly on Windows Docker Desktop without local C++ compiler dependencies.
- [x] Replaced local source build with official prebuilt Microsoft MCR image (`mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf`).
- [x] Zero compilation and zero local build time verified (`docker compose up -d`).
- [x] Model persistence verified via `./models` bind mount across container rebuilds.
- [x] BitNet server listens on container port `11434` mapped to host `8080`.
- [x] `/v1/models` and `/v1/chat/completions` respond with standard OpenAI payloads.
- [x] Built-in Web UI accessible at `http://localhost:8080/`.
- [x] Complete isolation from host Ollama runtime (:11434) verified.
- [x] Implemented Windows Portable distribution architecture (04.md / 04a.md) with portable launcher scripts (`portable/start.bat`, `portable/start.ps1`).
- [x] Added GitHub Actions CI workflow (`.github/workflows/build-windows-portable.yml`) to compile and package standalone `bitnet-windows-x64.zip` with zero local build requirements on user laptops.
- [x] Deployed Tier 3 Production Architecture to AMD VPS via Portainer.
- [x] Implemented API security hardening (API Keys, Context Bounding, Docker Resource Limits, Log Rotation, Localhost Binding).
