## Walkthrough: How to Download & Run BitNet on a Low-End Laptop / Desktop (No Docker)

Because BitNet uses 1.58-bit ternary quantization, it requires **only ~230 MB of RAM** and runs fast on **standard CPUs without any GPU or Docker Desktop**.

```text
               +-------------------------------------------+
               |          Your Low-End Laptop              |
               |                                           |
               |   1. Download bitnet-windows-x64.zip      |
               |   2. Extract to C:\bitnet\                |
               |   3. Place ggml-model-i2_s.gguf in models |
               |   4. Double-click start.bat               |
               |                                           |
               |   Open Browser: http://localhost:8080/    |
               +-------------------------------------------+
```

---

### Step 1: Download the Portable Runtime ZIP

1. Open your repository's GitHub Actions / Releases page:
   👉 **[https://github.com/AlamiaSoft/ms-bitnet/actions](https://github.com/AlamiaSoft/ms-bitnet/actions)** *(or Releases)*
2. Under the workflow **"Build Windows Portable Release"**, click the latest run and download **`bitnet-windows-x64.zip`**.
3. Extract the ZIP to any folder on your laptop (e.g., `C:\bitnet\` or `Desktop\bitnet\`).

Inside the extracted folder, you will see:
```text
bitnet-windows-x64/
├── bin/
│   ├── llama-server.exe     # Standalone C++ inference server
│   └── llama-cli.exe        # Standalone C++ CLI tool
├── models/                  # Folder for model weights
├── start.bat                # 1-Click launcher (CMD)
├── start.ps1                # PowerShell launcher (with auto-download)
└── README.md
```

---

### Step 2: Download the 1.58-bit Model (~1.18 GB)

You only need a single file: **`ggml-model-i2_s.gguf`**.

* **Option A (Automated)**: Right-click **`start.ps1`** → **Run with PowerShell**. If the model is missing, it will ask:
  ```text
  Would you like to download 'ggml-model-i2_s.gguf' (~1.2 GB) from Hugging Face now? (Y/N)
  ```
  Type `Y` and press Enter. It downloads directly into `models\`.

* **Option B (Manual direct link)**:
  Download the file directly from Hugging Face:
  🔗 **[Download ggml-model-i2_s.gguf (Direct Link)](https://huggingface.co/microsoft/BitNet-b1.58-2B-4T-gguf/resolve/main/ggml-model-i2_s.gguf)**
  and save it in the `models/` folder as `models\ggml-model-i2_s.gguf`.

---

### Step 3: Launch the Server

Double-click **`start.bat`**.

A command prompt will open showing:
```text
============================================================
 Starting Microsoft BitNet Portable Server (No Docker)
============================================================
- Port:        http://localhost:8080
- Model:       models\ggml-model-i2_s.gguf
- Threads:     4
- Web UI:      http://localhost:8080/?new_chat=true#/

Starting server... Press Ctrl+C to stop.
============================================================
```

---

### Step 4: Chat in Your Browser or Use the API

1. **Interactive Web Chat UI**:
   Open **`http://localhost:8080/?new_chat=true#/`** in Chrome, Edge, or Firefox. You can now chat directly with BitNet.
2. **OpenAI-Compatible API**:
   Any local tool, extension, or script can connect to:
   * Base URL: `http://localhost:8080/v1`
   * Model: `BitNet-b1.58-2B-4T`

---

### Expected Performance on Low-End Hardware

| Resource | Typical Measurement | Notes |
| :--- | :--- | :--- |
| **RAM Usage** | **~230 MB - 300 MB** | Extremely lightweight; leaves rest of RAM free for OS |
| **CPU Usage** | 4 threads | Runs on dual-core / quad-core Intel Core i3/i5/i7 or AMD Ryzen |
| **Inference Speed** | **~15 to 30 tokens/sec** | Faster than human reading speed on pure CPU |
| **GPU Required?** | **No** (0% GPU needed) | Uses integer lookup table kernel instructions |
