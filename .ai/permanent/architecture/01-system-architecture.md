# System Architecture: Microsoft BitNet 1-Bit LLM on Windows Docker

## 1. Intent & Scope

This project is a technical spike / Proof of Concept (PoC) to containerize Microsoft's BitNet (1.58-bit LLM runtime) in a Linux Docker container running on Windows Docker Desktop. The service exposes a local HTTP inference server (OpenAI-compatible API) accessible by host applications, automated tests, and future AI gateway runtimes.

```
+-------------------------------------------------------------+
| Windows Host (WSL2 / Docker Desktop)                       |
|                                                             |
|   +-----------------------------------------------------+   |
|   | Linux BitNet Container (Ubuntu 22.04 / 24.04)       |   |
|   |                                                     |   |
|   |  +--------------------+    +---------------------+  |   |
|   |  | BitNet C++ Kernels |<---| bitnet.cpp runtime  |  |   |
|   |  +--------------------+    +----------+----------+  |   |
|   |                                       |             |   |
|   |                            +----------v----------+  |   |
|   |                            |    llama-server     |  |   |
|   |                            |   (0.0.0.0:8080)    |  |   |
|   |                            +----------+----------+  |   |
|   |                                       |             |   |
|   +---------------------------------------|-------------+   |
|                                           |                 |
|   Port 8080:8080                          v                 |
|   http://localhost:8080/v1 <--- Host App / Smoke Test       |
|                                                             |
|   (Isolated from Host Ollama @ localhost:11434)             |
+-------------------------------------------------------------+
```

---

## 2. Invariants & Guarantees

1. **Host & Ollama Isolation**:
   - The BitNet container operates on port 8080 (configurable via `BITNET_HOST_PORT`).
   - Host Ollama (`http://localhost:11434`) must never be touched, modified, or depended upon.
2. **CPU-First Architecture**:
   - Primary target is x86_64 AVX2/AVX-512 CPU execution via BitNet's `i2_s` / `tl2` kernels.
   - GPU / CUDA passthrough is intentionally out-of-scope for the initial PoC to guarantee broad portability without driver dependencies.
3. **Model Persistence**:
   - Models reside on the host in `./models` and are bind-mounted to `/models` inside the container.
   - Container destruction (`docker compose down`) must NOT delete downloaded models.
4. **Standard Protocol**:
   - The container exposes an HTTP server providing OpenAI-compatible endpoints (`/v1/models`, `/v1/chat/completions`, `/v1/completions`) and a health check (`/health` or `/v1/models`).
   - No proprietary or custom protocol wrapper is introduced.
5. **Portability**:
   - The Dockerfile and Docker Compose configurations must run cleanly on both Windows (via Docker Desktop / WSL2) and standard Linux VPS environments without image modification.

---

## 3. Tradeoffs & Decisions

| Decision | Alternative Considered | Rationale |
| :--- | :--- | :--- |
| **Native `llama-server`** | Custom Python FastAPI / Flask wrapper | `llama-server` built into `bitnet.cpp` (from llama.cpp submodule) natively provides high-performance C++ HTTP serving, streaming, continuous batching, and OpenAI API compatibility with zero Python runtime overhead during inference. |
| **CPU-First execution** | NVIDIA CUDA runtime | GPU passthrough in Docker on Windows requires NVIDIA Container Toolkit configuration and specific driver versions. CPU-first satisfies the core PoC goal of proving 1-bit inference on commodity hardware. |
| **Bind Mount for `./models`** | Docker Named Volumes / Baked-in Image | Baking models into images creates multi-gigabyte image sizes and prevents model swapping without rebuilding. Named volumes make manual model downloads less transparent on Windows. Bind mounts allow direct PowerShell downloading and verification. |
| **Multi-stage Docker Build** | Single-stage Build with Toolchain | Building BitNet requires Clang 18+, CMake 3.22+, and development packages. Multi-stage build isolates build tools to the builder layer and packages only necessary runtime binaries and shared libraries into the runtime image. |

---

## 4. Failure Modes & Mitigations

| Failure Mode | Root Cause | Mitigation / Recovery |
| :--- | :--- | :--- |
| **Port Conflict on 8080** | Another local service (or proxy) is occupying 8080. | Configure `BITNET_HOST_PORT` in `.env` or pass `-e BITNET_HOST_PORT=<port>`. |
| **Model GGUF Missing / Invalid Format** | HuggingFace download failed, corrupted, or not converted to GGUF format. | Automated download script (`scripts/download-model.ps1`) verifies file existence and checksums before container startup. |
| **Container Unhealthy** | Inference server crashed due to out-of-memory or incompatible CPU instruction set. | Inspect logs via `docker compose logs bitnet`. Health check query `/v1/models` fails fast with restart policy `unless-stopped`. |
| **Bind address 127.0.0.1 inside container** | Server binds to localhost loopback inside Docker network namespace. | Force server bind address to `0.0.0.0:8080` so Docker port forwarding routes external host traffic. |
