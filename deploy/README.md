# BitNet VPS Deployment Stack

This directory contains the Portainer-compatible Docker Compose stack for deploying the Microsoft BitNet 1.58-bit model on a VPS.

## Architecture

This stack is designed to be fully self-contained and secure:
1. It pulls the official Microsoft Docker image (`mcr.microsoft.com/appsvc/docs/sidecars/sample-experiment:bitnet-b1.58-2b-4t-gguf`). **Note:** This image already has the 1.2 GB model baked directly inside it, so no manual model downloading or volume mounting is required.
2. It maps the container's port to `127.0.0.1:11434` on the host. 
3. It does **not** expose ports to the public internet, keeping the API secure. Your Cloudflare Tunnel (or reverse proxy) will route traffic to it via localhost.

## Deployment via Portainer

1. Navigate to **Portainer > Stacks > Add Stack**.
2. Select **Git Repository** (or paste the contents of `docker-compose.yml`).
3. Set the repository URL to this project and path to `deploy/docker-compose.yml`.
4. Click **Deploy**.

## Cloudflare Tunnel Configuration

In your Cloudflare Zero Trust Dashboard, set up your public hostname (e.g., `ai.alamiaconnect.com`) to route traffic to the container via your server's localhost:
- **Service Type:** `HTTP`
- **URL:** `localhost:11434`

### Production Hardening & Security

Because this API is publicly facing, the stack includes multiple hardening constraints:
- **API Authentication:** You must set `BITNET_API_KEY` in your Portainer environment variables. All programmatic requests must include this header:
  `Authorization: Bearer <your-api-key>`
- **Cloudflare WAF:** It is highly recommended to create a **Rate Limiting Rule** in your Cloudflare dashboard for `ai.alamiaconnect.com` (e.g., Block if > 30 requests per minute) to prevent Denial of Wallet attacks.
- **Resource Limits:** Docker is configured to cap the CPU to 3 cores and RAM to 3GB to protect your VPS.

## Important Note on ARM64 VPS

The Microsoft MCR image (`mcr.microsoft.com/...`) is compiled for `linux/amd64`. If your VPS is an ARM64 machine (e.g., Ampere Altra or AWS Graviton), Docker will attempt to run it using Rosetta/QEMU emulation, which will severely impact performance or crash. For native ARM64 speeds, a dedicated multi-arch GHCR build pipeline will be required in the future.
