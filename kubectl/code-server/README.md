# code-server

Deploys [code-server](https://github.com/coder/code-server) (VS Code in browser) into a Kubernetes cluster using the [wheetazlab/ubi-devcontainer](https://github.com/wheetazlab/ubi-devcontainer) image.

## Prerequisites

- Kubernetes cluster with the Gateway API CRDs installed
- Longhorn storage class available
- Cloudflare Zero Trust operator deployed (for HTTPRoute ingress)

## Files

| File | Description |
|------|-------------|
| `namespace.yml` | `code-server` namespace with pod-security baseline labels |
| `pvc.yml` | 10Gi PersistentVolumeClaim on longhorn for the `/root` home directory |
| `deployment.yml` | Deployment that runs code-server with no auth on port 8080 |
| `service.yml` | ClusterIP Service exposing port 8080 |
| `httproute.yml` | Gateway API HTTPRoute with Cloudflare Zero Trust annotations |

## Deploy

```bash
kubectl apply -f kubectl/code-server/
```

## Remove

```bash
kubectl delete -f kubectl/code-server/
```

## Configuration

Edit the relevant files before applying to change defaults:

| Setting | Default | File |
|---------|---------|------|
| Image | `ghcr.io/wheetazlab/ubi-devcontainer:latest` | `deployment.yml` |
| CPU request/limit | `500m` / `2` | `deployment.yml` |
| Memory request/limit | `512Mi` / `2Gi` | `deployment.yml` |
| Storage size | `10Gi` | `pvc.yml` |
| Storage class | `longhorn` | `pvc.yml` |
| Hostname | `vscode.wheethome.com` | `httproute.yml` |
| CFZT tenant | `wheethome` | `httproute.yml` |
| CFZT template | `protected-adauth-wheethome` | `httproute.yml` |

## Notes

- code-server is not baked into the image — it must be installed at `/root/.local/bin/code-server` inside the persistent volume. If not found on startup, the container sleeps until it is installed.
- The `/root` home directory is persisted via the PVC, so extensions, settings, and projects survive pod restarts.
