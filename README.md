# local-k8s-gitops

A fully local GitOps platform. **Terraform** provisions a multi-node **kind** Kubernetes cluster and installs **Argo CD** via Helm. Argo CD then continuously deploys an app to `dev` and `prod` environments from this repo using **Kustomize** overlays.

No cloud account needed.

## Architecture

```
 git push ──► GitHub repo ──► Argo CD (in cluster) ──► podinfo-dev  (1 replica)
                                   ▲                └► podinfo-prod (3 replicas)
 Terraform ──► kind cluster ──► Helm: argo-cd
```

## Stack
Terraform · kind · Helm · Argo CD (app-of-apps) · Kustomize · GitHub Actions · kubeconform

## Run it
Prereqs: Docker, Terraform, kubectl.

```bash
make up          # create cluster + install Argo CD
make bootstrap   # register root app; Argo CD syncs dev & prod
make password    # admin password
make ui          # open http://localhost:8080 (user: admin)
make down        # destroy everything
```

## Design choices
- **App-of-apps**: adding an environment means adding one file under `argocd/apps/`.
- **Self-heal + prune**: manual `kubectl` drift is reverted automatically.
- **Hardened pods**: non-root, no privilege escalation, resource limits, probes.
- **CI**: `terraform fmt/validate` and kubeconform schema checks on every push.

## Try GitOps
Change the message in `apps/podinfo/overlays/dev/kustomization.yaml`, push, and watch Argo CD roll it out.
