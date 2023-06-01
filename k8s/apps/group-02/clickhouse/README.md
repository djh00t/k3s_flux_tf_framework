# reloader

* Application GitHub: [github.com/ClickHouse/ClickHouse](https://github.com/ClickHouse/ClickHouse)
* Application Helm Repository: [Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse)
* Application Class: Application Dependency (Optional)

### Description

ClickHouse is an open-source column-oriented database management system that allows generating analytical data reports in real time. Its fast and has many interesting features like MySQL engine, Kafka interface, replication, sharding, etc.

### Directory Structure

This application contains 4 files and two directories by default:

* **README.md** - This README file.
* **app** \- This directory contains the application files.
* **config** \- This directory contains the configuration files.
* **ks-clickhouse.yaml** \- The kustomization definition for this application.
* **kustomization.yaml** \- Defines the files to include/exclude.
* **namespace.yaml** \- The namespace definition for this application.

```
├── README.md
├── app
├── config
├── ks-clickhouse.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-clickhouse.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 02-clickhouse
  namespace: flux-system
spec:
  path: ./k8s/apps/group-02/clickhouse/app/
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  interval: 5m
  retryInterval: 1m
  timeout: 3m
  wait: true
  dependsOn:
    - name: flux-system
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
  - ks-clickhouse.yaml
```

### namespace.yaml

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: clickhouse
  labels:
    reloader: enabled
```
