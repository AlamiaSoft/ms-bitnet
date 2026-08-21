# Microsoft BitNet - Windows Portable Distribution (No Docker)

This folder contains the packaging template and runner scripts for running **Microsoft BitNet locally on low-end Windows laptops without Docker, WSL2, or developer build tools**.

---

## 1. Quick Start for End Users

1. Download `bitnet-windows-x64.zip` from the project's GitHub Releases page.
2. Extract the ZIP archive anywhere on your PC (e.g. `C:\bitnet\`).
3. Place `ggml-model-i2_s.gguf` into the `models/` folder (or let `start.ps1` download it automatically).
4. Run `start.bat` (or right-click `start.ps1` -> *Run with PowerShell*).
5. Open `http://localhost:8080/` in your web browser.

---

## 2. Directory Layout

```text
bitnet-windows-x64/
├── bin/
│   ├── llama-server.exe     # Precompiled BitNet REST server
│   ├── llama-cli.exe        # Precompiled CLI inference tool
│   └── *.dll                # Dynamic runtime libraries
├── models/
│   └── ggml-model-i2_s.gguf # Model weights (~1.18 GB)
├── start.bat                # One-click Windows CMD launcher
├── start.ps1                # PowerShell launcher with auto-download
└── README.md                # This guide
```

---

## 3. How the Portable Binaries Are Built

The native Windows binaries in `bin/` are compiled automatically via GitHub Actions CI (`.github/workflows/build-windows-portable.yml`) using:
- **Runner**: `windows-latest`
- **Compiler**: Visual Studio 2022 + ClangCL
- **Target**: x86_64 with AVX2 kernel optimizations
- **Output**: `bitnet-windows-x64.zip` attached to GitHub Releases.

Zero local compilation or toolchains are needed on the user's laptop.
