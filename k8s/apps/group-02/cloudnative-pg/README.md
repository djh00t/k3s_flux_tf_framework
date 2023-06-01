# cloudnative-pg

* Application GitHub: [github.com/cloudnative-pg/cloudnative-pg](https://github.com/cloudnative-pg/cloudnative-pg)
* Application Helm Repository: [CloudNative-PG](https://cloudnative-pg.github.io/charts)
* Application Class: Application Dependency (Optional)

### Description

CloudNativePG is a Kubernetes operator that covers the full lifecycle of a PostgreSQL database cluster with a primary/standby architecture, using native streaming replication.

### Directory Structure

This application contains 4 files and two directories by default:

* **README.md** - This README file.
* **app** \- This directory contains the application files.
* **config** \- This directory contains the configuration files.
* **ks-cnpg.yaml** \- The kustomization definition for this application.
* **kustomization.yaml** \- Defines the files to include/exclude.
* **namespace.yaml** \- The namespace definition for this application.

```
├── README.md
├── app
├── config
├── ks-cnpg.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-cnpg.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 02-cloudnative-pg
  namespace: flux-system
spec:
  path: ./k8s/apps/group-02/cloudnative-pg/app/
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  interval: 30m
  retryInterval: 1m
  timeout: 3m
  wait: true
  healthChecks:
    - apiVersion: helm.toolkit.fluxcd.io/v2beta1
      kind: HelmRelease
      name: cloudnative-pg
      namespace: cloudnative-pg
  decryption:
    provider: sops
    secretRef:
      name: sops-age
  postBuild:
    substitute: { }
    substituteFrom:
      - kind: ConfigMap
        name: cluster-config
      - kind: Secret
        name: cluster-secrets
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 02-cloudnative-pg-config
  namespace: flux-system
spec:
  path: ./k8s/apps/group-02/cloudnative-pg/config/
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  interval: 30m
  retryInterval: 1m
  timeout: 3m
  dependsOn:
    - name: 02-cloudnative-pg
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
  postBuild:
    substitute: { }
    substituteFrom:
      - kind: ConfigMap
        name: cluster-config
      - kind: Secret
        name: cluster-secrets

```

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - namespace.yaml
  - ks-cnpg.yaml
```

### namespace.yaml

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cloudnative-pg
  labels:
    cloudnative-pg: enabled
```
