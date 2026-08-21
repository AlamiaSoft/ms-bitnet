# BitNet VPS Deployment Stack

This directory contains the Portainer-compatible Docker Compose stack for deploying the Microsoft BitNet 1.58-bit model on a VPS.

## Architecture

This stack is designed to be fully self-contained and secure:
1. It pulls the official Microsoft Docker image (`mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf`). **Note:** This image already has the 1.2 GB model baked directly inside it, so no manual model downloading or volume mounting is required.
2. It attaches strictly to the external `alamia-network`. 
3. It does **not** expose ports to the host public IP. Your Cloudflare Tunnel (or reverse proxy) will route traffic internally via the Docker network.

## Deployment via Portainer

1. Navigate to **Portainer > Stacks > Add Stack**.
2. Select **Git Repository** (or paste the contents of `docker-compose.yml`).
3. Set the repository URL to this project and path to `deploy/docker-compose.yml`.
4. Ensure the `alamia-network` exists in Docker before deploying (`docker network create alamia-network`).
5. Click **Deploy**.

## Cloudflare Tunnel Configuration

In your Cloudflare Zero Trust Dashboard, set up your public hostname (e.g., `bitnet.alamiaai.com`) to route traffic to the container using its internal DNS name:
- **Service Type:** `HTTP`
- **URL:** `bitnet-server:11434`

## Important Note on ARM64 VPS

The Microsoft MCR image (`mcr.microsoft.com/...`) is compiled for `linux/amd64`. If your VPS is an ARM64 machine (e.g., Ampere Altra or AWS Graviton), Docker will attempt to run it using Rosetta/QEMU emulation, which will severely impact performance or crash. For native ARM64 speeds, a dedicated multi-arch GHCR build pipeline will be required in the future.
