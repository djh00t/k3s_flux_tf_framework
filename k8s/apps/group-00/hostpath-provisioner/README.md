# hostpath-provisioner

* Application GitHub: [github.com/djh00t/hostpath-provisioner](https://github.com/djh00t/hostpath-provisioner)
* Application Class: Optional (May be used)

### Description

This application allows persistence of data between rebuilds of an application by specifying the physical location and name of a PV.

### Directory Structure

This application contains 3 files and 2 directories:

* **README.md** \- This README file\.
* **app** \- Core application files which shouldn't require modification\.
    * **kustomization.yaml** \- Defines the files to include/exclude\.
    * **helm-release.yaml** \- The helm release file which defines the helm chart and release version to use\. This is also where configmaps and secrets can be included\.
    * **repo.yaml** \- The repository definition file used by helm\-release\.yaml\.
* **config** \- Directory where commonly altered configuration files\, configmaps and secrets live\.
    * **configmap.yaml** \- The configmap used to configure options for main application\.
* **ks-hostpath-provisioner.yaml** \- The kustomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.

```
├── README.md
├── app
│   ├── kustomization.yaml
│   ├── helm-release.yaml
│   └── repo.yaml
├── config
│   └── configmap.yaml
├── ks-hostpath-provisioner.yaml
└── kustomization.yaml
```

## Example file formats

### app/kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
    - repo.yaml
    - ../config/configmap.yaml
    - release.yaml
```

### app/helm-release.yaml

```yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: hostpath-provisioner
  namespace: kube-system
spec:
  chart:
    spec:
      chart: hostpath-provisioner
      version: 0.2.13
      sourceRef:
        kind: HelmRepository
        name: hostpath-provisioner
        namespace: flux-system
  interval: 15m
  timeout: 5m
  releaseName: hostpath-provisioner
  valuesFrom:
  - kind: ConfigMap
    name: hostpath-provisioner-helm-chart-value-overrides
    valuesKey: values.yaml # This is the default, but best to be explicit for clarity
```

### config/configmap.yaml

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
    name: hostpath-provisioner-helm-chart-value-overrides
    namespace: kube-system
data:
  values.yaml: |-
    # Default values for hostpath-provisioner.
    # This is a YAML-formatted file.
    # Declare variables to be passed into your templates.
    strategyType: Recreate
    image:
      # Note: This is forked from its original repo to enable both amd64 and arm64
      # arm64 was not supported by the original repo.
      repository: djh00t/hostpath-provisioner
      # Note that by default we use appVersion to get image tag
      # tag:
      pullPolicy: Always
    ## For creating the StorageClass automatically:
    storageClass:
      create: true
      ## Set StorageClass as the default StorageClass
      ## Ignored if storageClass.create is false
      defaultClass: true
      ## Set a StorageClass name
      name: hostpath
    ## Set the provisioner name
    provisionerName: hostpath
    ## Set the reclaimPolicy
    reclaimPolicy: Retain
    ## Set the local HostPath to be used on the node
    nodeHostPath: /data/hostpath
    ## Node selector
    nodeSelector: {}
    ## Affinity
    affinity: {}
    ## Tolerations
    tolerations: []
    rbac:
      create: true
      ## Ignored if rbac.create is true
      serviceAccountName: default
    resources:
      limits:
        cpu: 100m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi
```

### ks-hostpath-provisioner.yaml

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 00-host-path-provisioner
  namespace: flux-system
spec:
  interval: 1m0s
  timeout: 15m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  prune: true
  path: ./k8s/apps/group-00/hostpath-provisioner/app
```

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
    - ks-hostpath-provisioner.yaml
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.