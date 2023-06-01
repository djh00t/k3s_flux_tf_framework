# external-dns

* Application GitHub: [github.com/kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)
* Application Helm Repository: [Bitnami](https://charts.bitnami.com/bitnami)
* Application Class: Core (strongly recommended)

### Description

This directory contains files that are used to configure external-dns.

### Directory Structure

This application contains 3 files and 3 directories by default:

* **README.md** - This README file.
* **app** - This directory contains the application files.
* **config** - This directory contains the configuration files.
* **ks-external-dns.yaml** - The kustomization definition for this application.
* **kustomization.yaml** - Defines the files to include/exclude.
* **zones** - This directory contains DNS zone configuration files.

```
├── README.md
├── app
│   ├── helm-release.yaml
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   └── repo.yaml
├── config
│   ├── README.md
│   ├── configmap.yaml
│   └── external-dns.secrets.sops.yaml
├── ks-external-dns.yaml
├── kustomization.yaml
└── zones
    ├── README.md
    ├── kustomization.yaml
    └── zone-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
```

## Example file formats

### ks-external-dns.yaml

*Note:* This file containse two kustomizations. The first one is the application itself and the second one is the configuration for the zones. This is done to allow for the zones to be managed separately from the application itself.

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: external-dns
  namespace: flux-system
spec:
  interval: 1m0s
  timeout: 15m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  prune: true
  path: ./k8s/apps/external-dns/app
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
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: external-dns-zones
  namespace: flux-system
spec:
  interval: 1m0s
  timeout: 15m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  prune: true
  path: ./k8s/apps/external-dns/zones
  dependsOn:
    - name: external-dns
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
  - ks-external-dns.yaml
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.
