# certs directory

* Application GitHub: [github.com/cert-manager/cert-manager](https://github.com/cert-manager/cert-manager)

### Description

This directory contains files that are used to define certificates for cert-manager to generate and manage.

### Directory Structure

This application contains 6 files by default:

* **README.md** \- This README file\.
* **infra\_domain.wildcard.yaml** \- This is the file that defines the default wildcard certificate for your cluster and the infra\_domain defined in cluster\-config\. You should not need to modify this file \- we recommend using it as a template for any additional certificates you wish to create to ensure updates don't overwrite your custom configs\.
* **kustomization.yaml** \- This is the kustomization file that defines the files to apply\.
* **letsencrypt-production.yaml** \- This is the production configuration file for Lets Encrypt\. Generally the only changes you will need to make are the acme solver you wish to use and any additional DNS zones you may need to add for the solver\.
* **letsencrypt-staging.yaml** \- This is the staging configuration file for Lets Encrypt\. Generally the only changes you will need to make are the acme solver you wish to use and any additional DNS zones you may need to add for the solver\.
* **self-signed-issuer.yaml** \- This is the configuration file for self signed certificates which can be used for internal pod to pod communications\.

**Please note:** *If you are adding or removing files in the certificates directory you will need to modify the kustomization.yaml file.*

```
├── README.md
├── infra_domain.wildcard.yaml
├── kustomization.yaml
├── letsencrypt-production.yaml
├── letsencrypt-staging.yaml
└── self-signed-issuer.yaml
```

## Example file formats

### infra\_domain.wildcard.yaml

```yaml
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cert-manager-wildcard-${CONFIG_INFRA_DOMAIN}
  namespace: cert-manager-wildcard
spec:
  secretName: cert-manager-wildcard-${CONFIG_INFRA_DOMAIN}
  issuerRef:
    ### Comment/uncomment the two lines below to switch between staging and production issuers
    name: letsencrypt-staging
    # name: letsencrypt-production
    kind: ClusterIssuer
  dnsNames:
    - "${CONFIG_INFRA_DOMAIN}"
    - "*.${CONFIG_INFRA_DOMAIN}"
    - "*.${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}"
  ### You can add additional domains to the list above or you can create a new certificate file
  ### in the same format as this file.
```

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - infra_domain.wildcard.yaml
  - letsencrypt-staging.yaml
  - letsencrypt-production.yaml
```

### letsencrypt-production.yaml

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
  namespace: cert-manager
spec:
  acme:
    email: certs-${CONFIG_INFRA_CLUSTER}@${CONFIG_INFRA_DOMAIN}
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
    - selector:
        ###
        ### Add any additional domains you wish to use to this list
        ###
        dnsZones:
          - ${CONFIG_INFRA_DOMAIN}
          - ${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      ###
      ### dns01 (recommended) solver
      ###
      dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cert-manager-secrets
            key: SECRET_CF_API_TOKEN
      ###
      ### http01 (Default) solver
      ###
      # http01:
      #   ingress:
      #     class: nginx
      ### Uncomment the following lines to use Cloudflare DNS01 challenges instead of HTTP01
      ### Note: You can not use both HTTP01 and DNS01 challenges at the same time for the same domain.
      ### You will also need to make sure you have the Cloudflare API key and email address defined
      ### in the config/cert-manager.secrets.sops.yaml file.
```

### letsencrypt-staging.yaml

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: cert-manager
spec:
  acme:
    email: certs-${CONFIG_INFRA_CLUSTER}@${CONFIG_INFRA_DOMAIN}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - selector:
        ###
        ### Add any additional domains you wish to use to this list
        ###
        dnsZones:
          - ${CONFIG_INFRA_DOMAIN}
          - ${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}
      ###
      ### dns01 (recommended) solver
      ###
      dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cert-manager-secrets
            key: SECRET_CF_API_TOKEN
      ###
      ### http01 (Default) solver
      ###
      # http01:
      #   ingress:
      #     class: nginx
      ### Uncomment the following lines to use Cloudflare DNS01 challenges instead of HTTP01
      ### Note: You can not use both HTTP01 and DNS01 challenges at the same time for the same domain.
      ### You will also need to make sure you have the Cloudflare API key and email address defined
      ### in the config/cert-manager.secrets.sops.yaml file.
```
### self-signed-issuer.yaml

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: selfsigned-ca
  secretName: selfsigned-ca
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: ca-issuer
  namespace: cert-manager
spec:
  ca:
    secretName: selfsigned-ca
```
