# cluster-config

* Application GitHub: [github.com/djh00t/k3s_flux_tf_framework](https://github.com/djh00t/k3s_flux_tf_framework)
* Application Class: Critical (Must be used)

### Description

This application contains configuration variables and secrets required by the cluster. Generally to exist in these configuration files the variable either manage kubernetes itself or they are used by multiple applications and therefore should be managed in a single place.

### Directory Structure

This application contains 3 configuration files in the config directory:

* **cluster.configmap.sops.yaml** \- This file contains configuration variables for the whole cluster\.
* **cluster.secrets.sops.yaml** \- This file contains secrets for the whole cluster\.
* **kustomization.yaml** \- This file is used to make sure kustomize knows which files to use\.

```
├── cluster-config.yaml
├── config
│   ├── cluster.configmap.sops.yaml
│   ├── cluster.secrets.sops.yaml
│   └── kustomization.yaml
└── kustomization.yaml
```

## Example file formats

### cluster.configmap.sops.yaml

*Note:* We use sops to encrypt the variables in this file as it allows us to store the file in git and have it automatically decrypted by flux. If you don't want to use sops you can replace the .sops.yaml file extension with .yaml and sops will no longer encrypt it.

```
apiVersion: v1
kind: ConfigMap
metadata:
    name: cluster-config
    namespace: flux-system
data:
    CONFIG_INFRA_DOMAIN: test.com
    CONFIG_INFRA_CLUSTER: dev
    CONFIG_STORAGE_CLASS: local-path
    CONFIG_TIMEZONE: UTC
    # K8S01 BGP Config - if using metallb and BGP
    CONFIG_K8S01_HOSTNAME: k8s01
    CONFIG_K8S01_BGP_ASN: "64956"
    CONFIG_K8S01_BGP_INTERNET_PEER_ASN: "64098"
    CONFIG_K8S01_BGP_MGMT_PEER_ASN: "65023"
    CONFIG_K8S01_BGP_INTERNET_PEER: 103.0.0.1
    CONFIG_K8S01_BGP_INTERNET_ADDRESS: 103.0.0.2
    CONFIG_K8S01_BGP_MGMT_ADDRESS: 172.18.100.2
    CONFIG_K8S01_BGP_MGMT_PEER: 172.18.100.1
```

### cluster.secrets.sops.yaml

```
apiVersion: v1
kind: Secret
metadata:
    name: cluster-secrets
    namespace: flux-system
stringData:
    SECRET_GRAFANA_ADMIN_PASSWORD: password123
    SECRET_INGRESS_MGMT_IPV4: 10.24.100.0
    SECRET_INGRESS_PUBLIC_IPV4: 10.0.0.1
    SECRET_PUSHOVER_ALERT_MANAGER_APIKEY: password123
    SECRET_PUSHOVER_USERKEY: admin
    SECRET_CF_API_EMAIL: certs@test.com                       <-- Put Cloudflare API details here if using
    SECRET_CF_API_KEY: abcdefghijklmnopqrstuvwxyz01234567890  <-- the same credentials for multiple applications
    SECRET_HEADSCALE_ADMIN: admin
    SECRET_HEADSCALE_PASSWORD: password123
    SECRET_HEADSCALE_KEY: 00771687-E8CB-4D1B-AEBE-D04DEA53FC68
    SECRET_HEADSCALE_OIDC_CLIENT_ID: 51F0BECE
    SECRET_HEADSCALE_OIDC_CLIENT_SECRET: 666D0FEC-B9E4-48CB-A03C-B408E4310AA9
    SECRET_HEADSCALE_OIDC_WEBUI_CLIENT_ID: 51F0BECE
    SECRET_HEADSCALE_OIDC_WEBUI_CLIENT_SECRET: 666D0FEC-B9E4-48CB-A03C-B408E4310AA9
```

### kustomization.yaml

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
    - cluster.configmap.sops.yaml
    - cluster.secrets.sops.yaml
```
