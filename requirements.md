# Task: Dockerize Microsoft BitNet 1-Bit LLM on Windows

## Objective

Set up a **working Linux-based Docker container on Windows** that runs Microsoft's BitNet 1-bit LLM locally and exposes it through an HTTP API suitable for consumption by applications and future AI-agent runtimes.

This is a **technical spike / PoC**, not a production deployment.

The primary goal is to prove:

```text
Windows Host
    ↓
Docker Desktop
    ↓
Linux BitNet Container
    ↓
BitNet 1-bit LLM
    ↓
llama-server / BitNet inference server
    ↓
OpenAI-compatible HTTP API
    ↓
curl / Python test client
```

The implementation must be portable enough that the same container setup can later be deployed to a Linux VPS with minimal changes.

---

# 1. Scope

## MUST implement

1. Linux-based Docker image for Microsoft's BitNet runtime.
2. BitNet inference runtime inside the container.
3. Download/install one appropriate small official BitNet model.
4. Run the model locally.
5. Expose an HTTP inference API from the container.
6. Prefer the existing BitNet/llama.cpp-compatible server functionality rather than inventing a custom inference protocol.
7. Provide an OpenAI-compatible `/v1` API if supported by the selected server.
8. Provide Docker Compose configuration.
9. Persist downloaded models through a Docker volume or bind mount.
10. Provide health-check functionality.
11. Provide simple CLI/curl test commands.
12. Provide a small Python smoke-test client.
13. Document Windows setup and operation.
14. Verify that the container works independently of Ollama.

## MUST NOT implement

Do NOT:

* install Ollama inside Docker
* modify the user's existing Ollama installation
* stop/restart Ollama
* change anything under `localhost:11434`
* build an Ollama integration
* install OpenRouter
* install OpenAI/Anthropic/etc. clients requiring cloud API keys
* build the future agent runtime
* build an AI gateway
* build a model router
* build authentication
* build a web UI
* build a SaaS
* expose the service publicly to the Internet
* require Kubernetes
* require a cloud VPS
* modify unrelated repositories/projects

Ollama already exists on the host and can later be treated as an external inference provider at:

```text
http://localhost:11434
```

Leave it completely untouched in this task.

---

# 2. Important Architectural Principle

Do NOT couple the future architecture to BitNet.

The immediate implementation should be:

```text
Application
    ↓
HTTP
    ↓
BitNet inference service
```

But structure the repository so that a future AI gateway/provider abstraction can sit in front of it.

For now, BitNet is simply one inference backend.

Do not implement that abstraction yet.

---

# 3. Repository Structure

Create a self-contained project with a structure approximately like:

```text
bitnet-docker/
├── docker-compose.yml
├── Dockerfile
├── .dockerignore
├── .gitignore
├── README.md
├── Makefile              # optional; only if useful on Windows/Linux
│
├── config/
│   └── ...
│
├── models/
│   └── .gitkeep
│
├── scripts/
│   ├── build.ps1
│   ├── start.ps1
│   ├── stop.ps1
│   ├── test.ps1
│   └── download-model.ps1
│
└── tests/
    └── smoke_test.py
```

Adjust the exact structure if BitNet's current build process requires something different.

Do not blindly follow old BitNet documentation if the current repository has changed.

---

# 4. Use Microsoft's Current BitNet Repository

Use the current Microsoft BitNet implementation from:

```text
https://github.com/microsoft/BitNet
```

Do not use an unrelated third-party BitNet implementation unless absolutely necessary.

Before implementing:

1. Inspect the current repository.
2. Determine the current recommended Linux build procedure.
3. Determine the current supported model format.
4. Determine the current recommended inference server.
5. Determine how the official example launches inference.
6. Determine whether the current server exposes OpenAI-compatible endpoints.
7. Follow the current implementation rather than assuming older commands are still valid.

If the repository has changed since older tutorials/documentation, prefer the current repository state.

---

# 5. Docker Base Image

Use a lightweight Linux base suitable for building/running BitNet.

Prefer:

```text
Ubuntu 22.04 or Ubuntu 24.04
```

unless the current BitNet build requires another distribution.

The container should contain only what is necessary:

* compiler/build dependencies
* BitNet source/runtime
* required native libraries
* inference server
* model runtime

Avoid unnecessary development packages in the final runtime layer where practical.

A multi-stage Docker build is preferred if it materially reduces the final image size.

---

# 6. CPU First

The first implementation MUST be CPU-first.

Do not make NVIDIA CUDA support a prerequisite.

The user's host is:

```text
Windows
Docker Desktop
32 GB RAM
NVIDIA GTX 1080 Ti
11 GB VRAM
```

But the initial goal is to prove that BitNet can run reliably in a Linux container using CPU.

GPU acceleration may be investigated later as a separate task.

Do not make the PoC fail simply because CUDA/GPU passthrough is unavailable.

---

# 7. Model

Install/download **one small official BitNet model suitable for the PoC**.

Prefer the official:

```text
BitNet-b1.58-2B-4T
```

or the current officially recommended small BitNet model if the repository has changed the preferred model.

Do NOT download multiple models.

The purpose is to establish the serving architecture, not benchmark the model zoo.

Models must NOT be baked unnecessarily into the Docker image.

Prefer:

```text
Docker container
      +
persistent ./models volume
```

so that models survive container recreation.

Document the model's approximate disk/RAM requirements.

---

# 8. Inference Server

Use the inference server provided/recommended by the current BitNet implementation.

If the current BitNet repository uses `llama-server`, use that.

The server should listen on:

```text
0.0.0.0:8080
```

inside the container.

Map it to an available host port, preferably:

```text
8080:8080
```

unless port 8080 is unavailable.

If 8080 is already occupied, make the host port configurable through an environment variable.

Example:

```text
BITNET_HOST_PORT=8080
```

---

# 9. API

Expose the server's HTTP API.

Prefer OpenAI-compatible endpoints where the underlying BitNet server supports them.

At minimum verify:

```text
GET /v1/models

POST /v1/chat/completions
```

If the current server exposes:

```text
POST /v1/completions
```

verify that as well.

Do NOT create a custom API wrapper unless the current BitNet server does not provide an adequate API.

If an OpenAI-compatible endpoint already exists, use it directly.

---

# 10. Health Check

Implement a Docker health check.

The health check should verify that the inference server is responding.

Do not use a health check that causes the model to perform an expensive generation.

Prefer something equivalent to:

```text
GET /health
```

or:

```text
GET /v1/models
```

depending on what the current server supports.

Document the expected response.

---

# 11. Docker Compose

Create:

```text
docker-compose.yml
```

with at least:

```text
bitnet:
    build: .
    ports:
        - "${BITNET_HOST_PORT:-8080}:8080"
    volumes:
        - ./models:/models
    restart: unless-stopped
```

Adjust paths/environment variables according to the actual BitNet runtime.

The model path must be configurable.

Do not hard-code a developer-specific Windows path.

---

# 12. Environment Configuration

Create:

```text
.env.example
```

containing appropriate configuration such as:

```text
BITNET_HOST_PORT=8080
BITNET_MODEL=...
BITNET_THREADS=...
```

Only include variables that are actually supported.

Do not invent configuration variables that the runtime doesn't use.

---

# 13. Windows Developer Experience

The primary workflow should be simple.

A developer should be able to do approximately:

```powershell
git clone ...
cd bitnet-docker

docker compose build
docker compose up -d
```

Then:

```powershell
curl http://localhost:8080/v1/models
```

and finally send a test request.

Provide PowerShell-compatible commands in the README.

Do not assume Bash is available on Windows.

If Bash scripts are provided, they must be optional.

PowerShell scripts should be the primary Windows developer experience.

---

# 14. Smoke Test

Create:

```text
tests/smoke_test.py
```

It should:

1. Connect to the local BitNet HTTP API.
2. Verify `/v1/models`.
3. Send a simple chat completion.
4. Print:

   * HTTP status
   * model name
   * generated response
   * elapsed time
   * approximate generated tokens if available
   * tokens/sec if available from the server response or measurable locally

The test must not require:

* OpenAI API key
* cloud service
* Ollama
* external SaaS

It should communicate only with:

```text
http://localhost:8080
```

---

# 15. Functional Test Prompt

Use a prompt that tests more than "hello world".

For example:

```text
You are a software architecture assistant.

A restaurant SaaS needs:
- multiple independent restaurants
- each restaurant has its own menu
- customers can browse the menu
- customers can create orders
- restaurant staff can manage orders

Briefly describe the core entities and relationships you would create.
```

Do not expect perfect architecture.

The purpose is to prove:

```text
request
  ↓
HTTP API
  ↓
BitNet
  ↓
generated response
```

---

# 16. Performance Measurement

The smoke test should record at least:

```text
Model:
Prompt:
Generation time:
Output tokens:
Approx tokens/sec:
Container RAM:
```

If obtaining exact token counts is difficult, clearly mark the measurement as approximate.

Also document how to inspect container resources:

```powershell
docker stats
```

Do not fabricate benchmark numbers.

---

# 17. API Compatibility Test

After the service starts, demonstrate an OpenAI-style request.

For example, if supported:

```text
POST http://localhost:8080/v1/chat/completions
```

with:

```json
{
  "model": "<actual-model-id>",
  "messages": [
    {
      "role": "user",
      "content": "Explain what a multi-tenant SaaS application is in two sentences."
    }
  ],
  "temperature": 0.2
}
```

Use the actual model identifier returned by `/v1/models`.

Verify the response structure.

---

# 18. Ollama Isolation Test

Explicitly verify that BitNet works without Ollama.

The test environment should conceptually be:

```text
Windows Host
│
├── Ollama :11434       ← existing, untouched
│
└── Docker
    └── BitNet :8080    ← this project
```

BitNet must NOT depend on:

```text
localhost:11434
```

The README should explicitly state:

> Ollama is not required for BitNet and is not modified by this project.

Do not attempt to connect to Ollama.

---

# 19. Container Networking

The BitNet container should be independently usable.

Inside Docker:

```text
BitNet server → 0.0.0.0:8080
```

From Windows:

```text
localhost:8080
```

Do not use:

```text
127.0.0.1
```

as the server bind address inside the container because that would prevent host access.

---

# 20. Persistence

Deleting/recreating the container must NOT delete the model.

Test:

```text
docker compose down
docker compose up -d
```

and verify that the model remains available without downloading it again.

Document where the model files live on the host.

---

# 21. Error Handling

The README should cover at least:

### Container doesn't start

Commands:

```powershell
docker compose logs bitnet
```

### Port conflict

Show how to change:

```text
BITNET_HOST_PORT
```

### Model not found

Explain where the model should exist.

### Build failure

Document the exact build dependencies and the most likely failure points.

### Slow inference

Explain that the initial PoC is CPU-first and that performance depends heavily on CPU/model/context.

### Docker Desktop resource limits

Mention that Docker Desktop's allocated CPU/RAM can affect inference performance.

---

# 22. Security

For this local PoC:

* bind only to the local Docker-published port
* do not configure public Internet exposure
* do not add authentication yet
* do not expose the service through Cloudflare Tunnel
* do not expose it on a VPS yet

The objective is local validation.

---

# 23. VPS Portability

The Docker setup should not contain Windows-specific runtime assumptions.

The desired future workflow is:

```text
Windows Docker
       ↓
same Dockerfile
       ↓
Linux VPS
```

Only host-level configuration should change.

Do not implement VPS deployment now.

Just ensure the container itself is portable.

---

# 24. Acceptance Criteria

The task is COMPLETE only when all of the following are true:

## Build

* [ ] Docker image builds successfully on Windows Docker Desktop.
* [ ] Build does not require installing BitNet's native toolchain directly on Windows.
* [ ] Linux BitNet runtime is built inside Docker.

## Model

* [ ] One small official BitNet model is available.
* [ ] Model is stored outside the image using persistent storage.
* [ ] Model survives container recreation.

## Runtime

* [ ] BitNet starts successfully.
* [ ] Inference server listens on `0.0.0.0:8080`.
* [ ] Container remains healthy after startup.

## API

* [ ] `/v1/models` works.
* [ ] `/v1/chat/completions` works if supported by the current BitNet server.
* [ ] A real prompt produces a response.
* [ ] No cloud API is required.

## Windows

* [ ] PowerShell commands are documented.
* [ ] `docker compose up -d` starts the service.
* [ ] `localhost:8080` is reachable from Windows.

## Isolation

* [ ] Ollama is not modified.
* [ ] Ollama is not required.
* [ ] BitNet works independently of `localhost:11434`.

## Testing

* [ ] Python smoke test works.
* [ ] Basic performance metrics are captured.
* [ ] Docker resource usage can be inspected with `docker stats`.

## Documentation

* [ ] README explains architecture.
* [ ] README explains installation.
* [ ] README explains model setup.
* [ ] README explains startup/shutdown.
* [ ] README explains API usage.
* [ ] README explains troubleshooting.
* [ ] README documents the exact BitNet model/version used.
* [ ] README documents any deviations from Microsoft's current instructions.

---

# 25. Important Implementation Rule

Do not prematurely abstract this into the larger Local AI Engine.

This task is intentionally a **vertical spike**:

```text
Docker
  ↓
BitNet
  ↓
Model
  ↓
HTTP API
  ↓
Working local inference
```

Once this works, the next task will build the model/provider abstraction and integrate BitNet with the larger local AI runtime.

Keep this implementation clean and replaceable.

---

# 26. Final Deliverable

At the end, provide a concise implementation report containing:

1. What was implemented.
2. Exact BitNet commit/version used.
3. Exact model used.
4. Docker image/base image used.
5. API endpoint.
6. Example request.
7. Actual measured tokens/sec.
8. Approximate RAM usage.
9. Container startup time.
10. Whether CPU-only inference works.
11. Any problems/workarounds discovered.
12. Whether the resulting container is ready to be used as the BitNet provider for a future AI Gateway.

Most importantly:

**Do not declare success merely because the Docker image builds.**

Success means:

```text
Docker container starts
        ↓
BitNet model loads
        ↓
HTTP API responds
        ↓
real prompt generates output
        ↓
Windows host can consume it
        ↓
Ollama remains completely untouched
```
