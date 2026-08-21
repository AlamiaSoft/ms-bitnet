# Project Glossary

- **BitNet b1.58**: A 1-bit LLM architecture where weights are ternary: $\{-1, 0, +1\}$, achieving extreme memory reduction and compute efficiency with integer addition instead of floating-point multiplication.
- **`bitnet.cpp`**: Microsoft's official C++ inference framework for BitNet models, built on top of `llama.cpp` and optimized lookup table (LUT) kernels.
- **`llama-server`**: The C++ HTTP server utility in `llama.cpp`/`bitnet.cpp` that provides OpenAI-compatible REST endpoints (`/v1/chat/completions`, `/v1/models`).
- **GGUF**: Binary format used by `llama.cpp` and `bitnet.cpp` for storing quantized model weights and metadata.
- **`i2_s` / `tl2`**: BitNet quantization schemes:
  - `i2_s`: 2-bit signed integer representation for ternary weights.
  - `tl2`: Optimized T-MAC lookup table kernel for x86_64 CPU architecture.
- **Continuous Batching (`-cb`)**: Server optimization allowing concurrent requests to be batched dynamically.
