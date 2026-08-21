# Coding Standards & Conventions

## 1. PowerShell Scripts (`scripts/*.ps1`)
- **Compatibility**: Must run under standard Windows PowerShell 5.1 and PowerShell Core 7+.
- **Error Handling**: Use `$ErrorActionPreference = "Stop"` at script start.
- **Output & Feedback**: Provide clear, colored progress messages (`Write-Host -ForegroundColor Cyan ...`).
- **Idempotency**: Scripts should check preconditions (e.g. checking whether `./models` contains required GGUF files before downloading).

## 2. Docker & Containerization
- **Base Images**: Ubuntu 22.04 / 24.04 LTS.
- **Multi-Stage Builds**: Separate build-time dependencies (Clang 18, CMake, Python headers) from the slim runtime stage.
- **Non-Root Execution**: Prefer running as non-root user where practical.
- **Deterministic Port & Path Mapping**: Expose `8080` internally, map to `BITNET_HOST_PORT` (default 8080).
- **Volumes**: Never bake large model weights into image layers; always bind mount `./models:/models`.

## 3. Python Test Client (`tests/smoke_test.py`)
- **Zero Heavy Dependencies**: Rely on Python standard library (`urllib.request`, `json`, `time`) or lightweight `requests` if necessary.
- **No Cloud Dependencies**: No OpenAI API keys, external SaaS, or cloud dependencies.
- **Structured Metrics**: Explicitly calculate and print latency, tokens/sec, and response status.
