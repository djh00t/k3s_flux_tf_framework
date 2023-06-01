# reloader

* Application GitHub: [github.com/cockroachdb/cockroach](https://github.com/cockroachdb/cockroach)
* Application Helm Repository: [CockroachDB](https://charts.cockroachdb.com/)
* Application Class: Application Dependency (Optional)

### Description

CockroachDB - the open source, cloud-native distributed SQL database.

### Directory Structure

This application contains 4 files and two directories by default:

* **README.md** - This README file.
* **app** \- This directory contains the application files.
* **config** \- This directory contains the configuration files.
* **ks-cockroachdb.yaml** \- The kustomization definition for this application.
* **kustomization.yaml** \- Defines the files to include/exclude.
* **namespace.yaml** \- The namespace definition for this application.

```
├── README.md
├── app
├── config
├── ks-cockroachdb.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-cockroachdb.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 02-cockroachdb
  namespace: flux-system
spec:
  path: ./k8s/apps/group-02/cockroachdb/app/
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  interval: 1m
  retryInterval: 1m
  timeout: 3m
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
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 02-cockroachdb-config
  namespace: flux-system
spec:
  path: ./k8s/apps/group-02/cockroachdb/config/
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  interval: 1m
  retryInterval: 1m
  timeout: 1m
  wait: true
  dependsOn:
    - name: 02-cockroachdb
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
  - ks-cockroachdb.yaml
```

### namespace.yaml

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cockroachdb
  labels:
    reloader: enabled
    auth: basic-auth
```