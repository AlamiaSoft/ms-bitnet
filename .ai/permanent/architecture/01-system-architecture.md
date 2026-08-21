# System Architecture: Microsoft BitNet 1-Bit LLM on Windows Docker

## 1. Intent & Scope

This project is a technical spike / Proof of Concept (PoC) to containerize Microsoft's BitNet (1.58-bit LLM runtime) in a Linux Docker container running on Windows Docker Desktop. The service exposes a local HTTP inference server (OpenAI-compatible API) accessible by host applications, automated tests, and future AI gateway runtimes.

```text
                               Microsoft BitNet Provider
                                          │
             ┌────────────────────────────┼────────────────────────────┐
             ▼                            ▼                            ▼
     Tier 1: Docker            Tier 2: Windows Portable        Tier 3: Public VPS
  (PCs / Workstations)            (Low-End Laptops)         (Production / Portainer)
             │                            │                            │
     Microsoft MCR Image           Standalone ZIP             Microsoft MCR Image
 (AVX2 / AVX512 Auto-detect)  (Built in GitHub Actions)        (Hardened Stack)
             │                            │                            │
   `docker compose up -d`            `start.bat`            `Cloudflare Zero Trust`
             │                            │                            │
             └────────────────────────────┼────────────────────────────┘
                                          │
                         OpenAI API: http://localhost:8080/v1
                         Web UI:     http://localhost:8080/
                                          │
                        (Tier 3 runs on localhost:11434 via Tunnel)
```

---

## 2. Invariants & Guarantees

1. **Host & Ollama Isolation**:
   - The BitNet server operates on host port 8080 (configurable via `BITNET_HOST_PORT`).
   - Host Ollama (`http://localhost:11434`) is never touched, modified, or conflicted with.
2. **Zero Local Compilation**:
   - Tier 1 consumes Microsoft's official prebuilt OCI image directly from MCR (`mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf`).
   - Tier 2 provides standalone native Windows binaries built in GitHub Actions CI (`.github/workflows/build-windows-portable.yml`).
3. **Tier 3 (Production) Hardening**:
   - Exposed solely through `127.0.0.1:11434` for Cloudflare Tunnel ingress, blocking all public internet exposure.
   - Enforces API Key Authentication (`Authorization: Bearer`), Docker resource constraints (Memory/CPU limits), container health checks, log rotation, and context window limits (`--ctx-size`).
3. **CPU-First Architecture**:
   - Primary target is x86_64 AVX2/AVX-512 CPU execution via BitNet's `i2_s` / `tl2` kernels with ~230 MB RAM footprint.
4. **Standard Protocol**:
   - Exposes standard OpenAI-compatible endpoints (`/v1/models`, `/v1/chat/completions`) and built-in chat UI (`/?new_chat=true#/`).

---

## 3. Tradeoffs & Decisions

| Decision | Alternative Considered | Rationale |
| :--- | :--- | :--- |
| **Official MCR Prebuilt Image** | Local Dockerfile source build | Using `mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf` eliminates 500+ MB of source code, multi-gigabyte build tools, and reduces startup time to seconds with zero local compilation. |
| **CI-Built Windows Portable ZIP** | Requiring Visual Studio / CMake on laptops | Compiling native `.exe` files in GitHub Actions CI allows low-end Windows laptops without Docker or compilers to run BitNet via a single `start.bat` script. |
| **Native `llama-server`** | Python FastAPI / Flask wrapper | `llama-server` natively provides high-performance C++ HTTP serving, streaming, continuous batching, and web UI with zero Python runtime overhead. |

---

## 4. Failure Modes & Mitigations

| Failure Mode | Root Cause | Mitigation / Recovery |
| :--- | :--- | :--- |
| **Port Conflict on 8080** | Another local service (or proxy) is occupying 8080. | Configure `BITNET_HOST_PORT` in `.env` or pass `-e BITNET_HOST_PORT=<port>`. |
| **Model GGUF Missing / Invalid Format** | HuggingFace download failed, corrupted, or not converted to GGUF format. | Automated download script (`scripts/download-model.ps1`) verifies file existence and checksums before container startup. |
| **Container Unhealthy** | Inference server crashed due to out-of-memory or incompatible CPU instruction set. | Inspect logs via `docker compose logs bitnet`. Health check query `/v1/models` fails fast with restart policy `unless-stopped`. |
| **Bind address 127.0.0.1 inside container** | Server binds to localhost loopback inside Docker network namespace. | Force server bind address to `0.0.0.0:8080` so Docker port forwarding routes external host traffic. |
