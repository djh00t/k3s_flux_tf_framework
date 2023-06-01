# nginx-ingress

* Application GitHub: [github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller)
* Application Helm Repository: [Bitnami](https://charts.bitnami.com/bitnami)
* Application Class: Core (strongly recommended)

### Description

This directory contains files that are used to configure the Bitnami version of nginx-ingress.

### Directory Structure

This application contains 4 files and two directories by default:

* **README.md** - This README file.
* **app** \- This directory contains the application files.
  * **configmap.yaml** \- The configuration for the application.
  * **helm-release.yaml** \- The HelmRelease definition for this application.
  * **kustomization.yaml** \- Defines the files to include/exclude.
  * **repo.yaml** \- The HelmRepository definition for this application.
* **config** \- This directory contains the configuration files.
* **ks-nginx-ingress.yaml** \- The kustomization definition for this application.
* **kustomization.yaml** \- Defines the files to include/exclude.
* **namespace.yaml** \- The namespace definition for this application.

```
├── README.md
├── app
│   ├── configmap.yaml
│   ├── helm-release.yaml
│   ├── kustomization.yaml
│   └── repo.yaml
├── config
├── ks-ingress-nginx.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-nginx-ingress.yaml

*Note:* This file contains two kustomizations. The first one is the application itself and the second one is the configuration. This is done to allow for the application and its configurations to be managed separately.

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: nginx-ingress
  namespace: flux-system
spec:
  interval: 10m
  path: "./k8s/apps/nginx-ingress/app"
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  wait: true
  dependsOn:
    - name: flux-system
  postBuild:
    substitute: { }
    substituteFrom:
      - kind: ConfigMap
        name: cluster-config
        optional: true
      - kind: Secret
        name: cluster-secrets
        optional: true
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: nginx-ingress-config
  namespace: flux-system
spec:
  interval: 10m
  path: "./k8s/apps/nginx-ingress/config"
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  wait: true
  dependsOn:
    - name: nginx-ingress
  postBuild:
    substitute: { }
    substituteFrom:
      - kind: ConfigMap
        name: cluster-config
        optional: true
      - kind: Secret
        name: cluster-secrets
        optional: true
```

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - namespace.yaml
  - ks-ingress-nginx.yaml
```

### namespace.yaml

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-ingress
  labels:
    reloader: enabled
```