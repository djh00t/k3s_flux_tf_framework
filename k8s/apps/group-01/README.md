# GROUP-01

* Application Class: Base cluster services & applications (recommended)

### Description

This group of applications are base services and applications required to run a production cluster. While some of these applications might be optional in your environment, most of them are important to understand before disabling them.

### Directory Structure

This application contains 6 subdirectories and 2 files:

* **README.md** \- This README file\.
* **cert-manager** \- Certificate manager adds certificates and certificate issuers as resource types in Kubernetes clusters\, and simplifies the process of obtaining\, renewing and using those certificates\.
* **config-syncer** \- Config Syncer by AppsCode keeps ConfigMaps and Secrets synchronized across namespaces and/or clusters\.
* **external-dns** \- Configure external DNS servers \(AWS Route53\, Google CloudDNS and others\) for Kubernetes Ingresses and Services\.
* **monitoring** \- The Prometheus monitoring system and time series database\.
* **nginx-ingress** \- This directory contains files that are used to configure the Bitnami version of nginx\-ingress\.
* **reloader** \- Reloader can watch changes in ConfigMap and Secret and do rolling upgrades on Pods with their associated DeploymentConfigs\, Deployments\, Daemonsets Statefulsets and Rollouts\.

**Please note:** *If you add or remove files - please remember to alter the kustomization.yaml file that refers to them and this README.md file. If you are adding or removing items in the config directory you will need to modify the appropriate kustomization.yaml file.*

```
.
├── README.md
├── cert-manager
├── config-syncer
├── external-dns
├── kustomization.yaml
├── monitoring
├── nginx-ingress
└── reloader
```

To enable or disable this group, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.
