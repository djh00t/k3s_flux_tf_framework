# cluster-config

* Application GitHub: [github.com/djh00t/k3s_flux_tf_framework](https://github.com/djh00t/k3s_flux_tf_framework)
* Application Class: Critical (Must be used)

### Description

This application contains configuration variables and secrets required by the cluster. Generally to exist in these configuration files the variable either manage kubernetes itself or they are used by multiple applications and therefore should be managed in a single place.

### Directory Structure

This application contains 2 files and 1 directory:

* **README.md** \- This documentation file\.
* **config** \- Directory where commonly altered configuration files\, configmaps and secrets live\.
* **ks-cluster-config.yaml** \- The kustomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.

```
├── config
├── ks-cluster-config.yaml
└── kustomization.yaml
```

## Example file formats

### ks-cluster-config.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 00-cluster-config
  namespace: flux-system
spec:
  interval: 1m0s
  timeout: 15m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  prune: true
  path: ./k8s/apps/group-00/cluster-config/config
  dependsOn:
    - name: flux-system
  decryption:
    provider: sops
    secretRef:
      name: sops-age
```

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ks-cluster-config.yaml
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.