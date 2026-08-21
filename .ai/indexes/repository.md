# Repository Concept & File Map

## Root Structure
- `Dockerfile`: Multi-stage build definition compiling `bitnet.cpp` and `llama-server` on Linux.
- `docker-compose.yml`: Compose service exposing port 8080 and bind-mounting `./models`.
- `.env.example`: Configuration variables (`BITNET_HOST_PORT`, `BITNET_MODEL`, `BITNET_THREADS`, `BITNET_CTX_SIZE`).
- `requirements.md`: Architectural requirements and constraints for the Dockerized BitNet technical spike.
- `README.md`: User documentation for setup, PowerShell execution, and troubleshooting.

## Subdirectories & Modules
- `bitnet-repo/`: Microsoft BitNet repository containing C++ kernels, Python build tooling, and `llama.cpp` integration.
- `models/`: Persistent directory for downloaded BitNet GGUF weight files.
- `scripts/`:
  - `build.ps1`: Builds the Docker image.
  - `start.ps1`: Starts the container via `docker compose up -d`.
  - `stop.ps1`: Stops the container via `docker compose down`.
  - `test.ps1`: Executes smoke tests against the running container.
  - `download-model.ps1`: Downloads official BitNet model weights from Hugging Face into `./models`.
- `tests/`:
  - `smoke_test.py`: Standalone Python client verifying `/v1/models` and `/v1/chat/completions` without external API keys.

## AI Knowledge System (`.ai/`)
- `permanent/architecture/`: Core system design, invariants, and failure modes.
- `permanent/standards/`: Coding and script conventions.
- `permanent/adr/`: Architectural Decision Records.
- `permanent/glossary/`: Terminology and abbreviations.
- `transient/sprint/`: Sprint goals and current state.
- `transient/backlog/`: Future roadmap items.
