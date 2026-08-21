# Repository Concept & File Map

## Root Structure
- `docker-compose.yml`: Compose service definition using the prebuilt Microsoft MCR image (`mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf`).
- `.env.example` & `.env`: Configuration variables (`BITNET_HOST_PORT`, `BITNET_THREADS`, `BITNET_REPEAT_PENALTY`, `BITNET_TOP_P`, `BITNET_MIN_P`).
- `requirements.md`: Architectural requirements and constraints.
- `README.md`: Developer and user documentation.

## Subdirectories & Modules
- `.github/workflows/`:
  - `build-windows-portable.yml`: GitHub Actions CI pipeline building the standalone Windows portable distribution.
- `portable/`:
  - `start.bat`: One-click Windows CMD launcher for portable execution without Docker.
  - `start.ps1`: PowerShell launcher with auto-download prompt for weights.
  - `README.md`: Guide for low-end laptop users.
- `models/`: Persistent directory for optional custom GGUF models.
- `scripts/`:
  - `start.ps1`: Starts the Docker container via `docker compose up -d` and polls health.
  - `stop.ps1`: Stops the Docker container via `docker compose down`.
  - `test.ps1`: Executes smoke tests against the running container.
  - `download-model.ps1`: Downloads BitNet model weights from Hugging Face.
- `tests/`:
  - `smoke_test.py`: Standalone Python test client verifying latency, tokens/sec, and deterministic repetition detection.

## AI Knowledge System (`.ai/`)
- `permanent/architecture/`: Core system design, invariants, and failure modes.
- `permanent/standards/`: Coding and script conventions.
- `permanent/adr/`: Architectural Decision Records.
- `permanent/glossary/`: Terminology and abbreviations.
- `transient/sprint/`: Sprint goals and current state.
- `transient/backlog/`: Future roadmap items.
