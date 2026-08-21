# ADR 0001: CPU-First Containerized Runtime with Native llama-server

## Status
Accepted

## Context
We need to validate local deployment of Microsoft's 1-bit LLM (BitNet) inside a Docker container on Windows Docker Desktop without depending on host tools or conflicting with existing local LLM tooling (such as Ollama on port 11434).

## Decision
1. **Container Environment**: Build a Linux-based Docker image (Ubuntu 22.04/24.04) compiling `bitnet.cpp` using Clang 18+ and CMake inside the container.
2. **Serving Layer**: Use `bitnet.cpp`'s native `llama-server` binary on port 8080.
3. **Execution Target**: Focus purely on CPU execution (x86_64 AVX2/AVX-512 with `i2_s` / `tl2` kernels) to avoid CUDA host driver requirements in this initial spike.
4. **Persistence**: Use a bind mount `./models:/models` so model files persist on the host filesystem across container rebuilds.

## Consequences
- **Positive**:
  - No native C++ or Clang toolchain requirements on the Windows host.
  - Zero Python inference overhead at runtime.
  - Full isolation from host Ollama runtime.
- **Negative / Limitations**:
  - CPU-bound inference speeds (though 1-bit models are specifically optimized for CPU throughput).
  - Multi-stage Docker build time is higher initially during binary compilation.
