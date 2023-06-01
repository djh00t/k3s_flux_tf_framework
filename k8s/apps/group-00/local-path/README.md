# 00-local-path

* Application GitHub: [github.com/djh00t/k3s_flux_tf_framework](https://github.com/djh00t/k3s_flux_tf_framework)
* Application Class: Critical (Must be used)

### Description

This application contains configuration variables that control where the cluster local-path storage-class keeps its data. You will need to make sure that the location you shoose is backed up and has enough space to store the data you intend to store on it.

### Directory Structure

This application contains 3 file and 1 directory:

* **README.md** \- This README file\.
* **config** \- Directory where commonly altered configuration files\, configmaps and secrets live\.
    * **kustomization.yaml** \- Defines the files to include/exclude\.
    * **sc-local-path.yaml** \- Storage Class that sets/unsets local\-path as the default storage class\. It should be set to false if you are using longhorn\, hostpath\-provisioner or another storage class as default\.
* **ks-local-path.yaml** \- The kustomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.

```
├── README.md
├── config
│   ├── kustomization.yaml
│   └── sc-local-path.yaml
├── ks-local-path.yaml
└── kustomization.yaml
```

## Example file formats

### config/kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
    - sc-local-path.yaml
```

### config/sc-local-path.yaml

```yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  labels:
    storage: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
```

### ks-local-path.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 00-local-path
  namespace: flux-system
spec:
  interval: 1m
  timeout: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  prune: true
  path: ./k8s/apps/group-00/local-path/config
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
    - config
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.