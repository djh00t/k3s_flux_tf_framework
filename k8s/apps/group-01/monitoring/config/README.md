# config directory

* Application GitHub URLs: 
    * [github.com/prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter)
    * [github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
    * [github.com/prometheus/snmp_exporter]

### Description

This directory contains files that are used to configure the prometheus monitoring stack.

### Directory Structure

This application contains 2 files by default:

* **README.md** \- This README file.
* **dashboards** \- This directory contains the json files for the grafana dashboards. These files are automatically loaded into grafana by the grafana-operator.
* **kustomization.yaml** - Defines the files to include/exclude.
* **podmonitor.yaml** - PodMonitor configuration file.
* **zone-alert-manager-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml** - external-dns zone file for alertmanager.
* **zone-grafana-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml** - external-dns zone file for grafana.

**Please note:** *If you are adding or removing files in the config directory you will need to modify the kustomization.yaml file.*

```
├── README.md
├── dashboards
│   ├── blackbox.json
│   ├── cluster.json
│   ├── control-plane.json
│   ├── logs.json
│   ├── longhorn.json
│   ├── proxmox.json
│   ├── snmp-stats_rev1.json
│   ├── tid-network.json
│   └── traefik-2_rev1.json
├── kustomization.yaml
├── podmonitor.yaml
├── zone-alert-manager-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
└── zone-grafana-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
```

## Example file formats

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: monitoring
resources:
  - zone-alert-manager-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
  - zone-grafana-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml
  - podmonitor.yaml
configMapGenerator:
  - name: grafana-dashboards
    files:
      - dashboards/control-plane.json
      - dashboards/cluster.json
      - dashboards/logs.json
      - dashboards/blackbox.json
      - dashboards/proxmox.json
      - dashboards/snmp-stats_rev1.json
      - dashboards/tid-network.json

    options:
      labels:
        grafana_dashboard: "1"
        app.kubernetes.io/part-of: flux
        app.kubernetes.io/component: monitoring
```

### pod-monitor.yaml

```yaml
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: flux-system
  namespace: flux-system
  labels:
    app.kubernetes.io/part-of: flux
    app.kubernetes.io/component: monitoring
spec:
  namespaceSelector:
    matchNames:
      - flux-system
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
          - helm-controller
          - source-controller
          - kustomize-controller
          - notification-controller
          - image-automation-controller
          - image-reflector-controller
  podMetricsEndpoints:
    - port: http-prom
```

### zone-alert-manager-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml

```yaml
---
apiVersion: externaldns.k8s.io/v1alpha1
kind: DNSEndpoint
metadata:
  name: alert-manager-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
  namespace: external-dns
spec:
  endpoints:
    - dnsName: alert-manager-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      recordTTL: 180
      recordType: CNAME
      targets:
        - ingress-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      providerSpecific:
        - name: external-dns.alpha.kubernetes.io/cloudflare-proxied
          value: 'true'
```

### zone-grafana-CONFIG_INFRA_CLUSTER.CONFIG_INFRA_DOMAIN.yaml

```yaml
---
apiVersion: externaldns.k8s.io/v1alpha1
kind: DNSEndpoint
metadata:
  name: grafana-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
  namespace: external-dns
spec:
  endpoints:
    - dnsName: grafana-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      recordTTL: 180
      recordType: CNAME
      targets:
        - ingress-${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      providerSpecific:
        - name: external-dns.alpha.kubernetes.io/cloudflare-proxied
          value: 'true'
```
