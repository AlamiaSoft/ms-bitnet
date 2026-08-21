# Project Backlog

## Post-PoC Epics & Tasks

1. **GPU Acceleration Spike**:
   - Evaluate NVIDIA CUDA container integration using `bitnet-repo/gpu` or CUDA-enabled llama.cpp build.
   - Benchmark throughput vs. CPU `i2_s` / `tl2` kernels.

2. **AI Gateway & Provider Abstraction**:
   - Design unified routing layer connecting BitNet (:8080) and Ollama (:11434).
   - Implement health-based load balancing and fallback mechanisms.

3. **Multi-Model Dynamic Loading**:
   - Provide runtime model selection mechanism in `llama-server` or router.

4. **Linux VPS CI/CD Pipeline**:
   - Validate automated container builds and deployment on headless Ubuntu VPS.
