# monitoring

* Application GitHub URLs: 
    * [github.com/prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter)
    * [github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
    * [github.com/prometheus/snmp_exporter](https://github.com/prometheus/snmp_exporter)
* Application Helm Repository: [prometheus-community-charts](https://prometheus-community.github.io/helm-charts)
* Application Class: Core (strongly recommended)

### Description

This directory contains files that are used to configure general monitoring tools for Kubernetes clusters.

### Directory Structure

This application contains 4 files and 2 directories by default:

* README.md - This README file.
* **app** \- This directory contains the application files an folders\.
    * **blackbox-exporter** \- The blackbox exporter allows blackbox probing of endpoints over HTTP\, HTTPS\, DNS\, TCP\, ICMP and gRPC\.
    * **kube-prometheus-stack** - Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.
    * **snmp-exporter** - This exporter is the recommended way to expose SNMP data in a format which Prometheus can ingest.
* **config** \- This directory contains the configuration files\.
    * **dashboards** - A collection of starter Grafana dashboards that expose various cluster metrics.
* **ks-ingress-nginx.yaml** \- The kustomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.
* **namespace.yaml** - The namespace configuration file.

```
├── README.md
├── app
│   ├── blackbox-exporter
│   ├── kube-prometheus-stack
│   ├── kustomization.yaml
│   ├── repo.yaml
│   └── snmp-exporter
├── config
│   ├── dashboards
│   ├── kustomization.yaml
│   ├── podmonitor.yaml
│   ├── zone-alert-manager-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
│   └── zone-grafana-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
├── ks-monitoring.yaml
├── kustomization.yaml
└── namespace.yaml
```

## Example file formats

### ks-monitoring.yaml

*Note:* This file contains two kustomizations. The first one is the application itself and the second one is the configuration. This is done to allow for the application and its configurations to be managed separately.

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: 01-monitoring
  namespace: flux-system
spec:
  interval: 60m
  timeout: 15m
  path: "./k8s/apps/group-01/monitoring/app"
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  dependsOn:
    - name: 00-cluster-config
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: kube-prometheus-stack-operator
      namespace: monitoring
    - apiVersion: apps/v1
      kind: Deployment
      name: kube-prometheus-stack-kube-state-metrics
      namespace: monitoring
    - apiVersion: apps/v1
      kind: Deployment
      name: kube-prometheus-stack-grafana
      namespace: monitoring
    - apiVersion: apps/v1
      kind: Deployment
      name: snmp-exporter-prometheus-snmp-exporter
      namespace: monitoring
    - apiVersion: apps/v1
      kind: Deployment
      name: blackbox-exporter-prometheus-blackbox-exporter
      namespace: monitoring
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
  name: 01-monitoring-config
  namespace: flux-system
spec:
  interval: 15m
  timeout: 5m
  path: "./k8s/apps/group-01/monitoring/config"
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
  dependsOn:
    - name: 01-monitoring
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
    - ks-monitoring.yaml
```
### namespace.yaml
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
  labels:
    # Enable config-reloader
    reloader: enabled
    # Enable basic-authentication on ingress-nginx
    auth: basic-auth
```