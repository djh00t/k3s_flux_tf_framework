# reloader

* Application GitHub: [github.com/stakater/Reloader](https://github.com/stakater/Reloader)
* Application Helm Repository: [Stakater](https://stakater.github.io/stakater-charts)
* Application Class: Core (strongly recommended)

### Description

Reloader can watch changes in ConfigMap and Secret and do rolling upgrades on Pods with their associated DeploymentConfigs, Deployments, Daemonsets Statefulsets and Rollouts.

### Directory Structure

This application contains 3 files and two directories by default:

* **README.md** - This README file.
* **app** \- This directory contains the application files.
  * **helm-release.yaml** \- The HelmRelease definition for this application.
  * **kustomization.yaml** \- Defines the files to include/exclude.
  * **repo.yaml** \- The HelmRepository definition for this application.
* **config** \- This directory contains the configuration files.
  * **configmap.yaml** \- The ConfigMap definition for this application.
* **ks-reloader.yaml** \- The kustomization definition for this application.
* **kustomization.yaml** \- Defines the files to include/exclude.
* **namespace.yaml** \- The namespace definition for this application.

```
├── README.md
├── app
│   ├── helm-release.yaml
│   ├── kustomization.yaml
│   └── repo.yaml
├── config
│   └── configmap.yaml
├── ks-reloader.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-reloader.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 01-reloader
  namespace: flux-system
spec:
  interval: 1m
  timeout: 5m
  path: "./k8s/apps/group-01/reloader/app"
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
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
  - ks-reloader.yaml
```

### namespace.yaml

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: reloader
```