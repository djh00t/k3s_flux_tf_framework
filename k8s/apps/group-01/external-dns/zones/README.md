# zones directory

* Application GitHub: [github.com/kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)

### Description

This directory contains files that are used to define DNS zones for external-dns to generate and manage.

### Directory Structure

This application contains 2 files by default:

* **kustomization.yaml** \- This is the kustomization file that defines the files to apply\.
* **${CONFIG_INFRA_CLUSTER}.${CONFIG_INFRA_DOMAIN}.yaml** \- This is the configuration file for your clusters infrastructure domain\.

**Please note:** *If you are adding or removing files in the certificates directory you will need to modify the kustomization.yaml file.*

```
├── kustomization.yaml
└── k8s.test.com.yaml
```

## Example file formats

### kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
    - k8s.test.com.yaml
```

### k8s.test.com.yaml

```yaml
---
apiVersion: externaldns.k8s.io/v1alpha1
kind: DNSEndpoint
metadata:
  name: k8s.test.com
  namespace: external-dns
spec:
  endpoints:
    - dnsName: k8s.test.com
      recordTTL: 180
      recordType: A
      targets:
        - 192.0.2.27
    - dnsName: k8s.test.com
      recordTTL: 180
      recordType: AAAA
      targets:
        - 2001:0DB8::beef
```
