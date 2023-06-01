# config directory

Application GitHub: [github.com/kubeops/config-syncer](https://github.com/kubeops/config-syncer)

### Description

This directory contains files that are used to configure config-syncer.

### Directory Structure

This application contains 1 files by default:

* **configmap.yaml** - This is the base configuration file for config-syncer.
* **README.md** - This README file.

**Please note:** *If you are adding or removing files in the config directory you will need to modify the app/kustomization.yaml file.*

```
├── app
│   └── kustomization.yaml
└── config
    ├── README.md
    └── configmap.yaml
```

## Example file formats

### ../app/kustomization.yaml

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - namespace.yaml
  - repo.yaml
  - ../config/configmap.yaml
  - release.yaml
```

### configmap.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: config-syncer-helm-chart-value-overrides
    namespace: config-syncer
data:
    values.yaml: |-
        # Default values for config-syncer.
        # This is a YAML-formatted file.
        # Declare variables to be passed into your templates.

        # Overrides name template
        nameOverride: ""
        # Overrides fullname template
        fullnameOverride: ""

        # Number of Config Syncer operator replicas to create (only 1 is supported)
        replicaCount: 1

        operator:
          # Docker registry used to pull Config Syncer operator image
          registry: ghcr.io/appscode
          # Config Syncer operator container image
          repository: config-syncer
          # Config Syncer operator container image tag
          tag: ""
          # Compute Resources required by the operator container
          resources: {}
          # Security options the operator container should run with
          securityContext: {}

        # Specify an array of imagePullSecrets.
        # Secrets must be manually created in the namespace.
        #
        # Example:
        # helm template charts/config-syncer \
        #   --set imagePullSecrets[0].name=sec0 \
        #   --set imagePullSecrets[1].name=sec1
        imagePullSecrets: []

        # Container image pull policy
        imagePullPolicy: IfNotPresent

        # If true, installs Config Syncer operator as critical addon
        criticalAddon: false

        # Log level for operator
        logLevel: 3

        # Annotations applied to operator deployment
        annotations: {}

        # Annotations passed to operator pod(s).
        podAnnotations: {}

        # Node labels for pod assignment
        nodeSelector: {}

        # Tolerations for pod assignment
        tolerations: []

        # Affinity rules for pod assignment
        affinity: {}

        # Security options the operator pod should run with.
        podSecurityContext:  # +doc-gen:break
          # ensure that s/a token is readable xref: https://issues.k8s.io/70679
          fsGroup: 65535

        serviceAccount:
          # Specifies whether a service account should be created
          create: true
          # Annotations to add to the service account
          annotations: {}
          # The name of the service account to use.
          # If not set and create is true, a name is generated using the fullname template
          name: ""

        apiserver:
          # Port used by Config Syncer server
          securePort: "8443"
          # If true, uses kube-apiserver FQDN for AKS cluster to workaround https://github.com/Azure/AKS/issues/522 (default true)
          useKubeapiserverFqdnForAks: true
          healthcheck:
            # healthcheck configures the readiness and liveliness probes for the operator pod.
            enabled: false
          servingCerts:
            # If true, generates on install/upgrade the certs that allow the kube-apiserver (and potentially ServiceMonitor)
            # to authenticate operators pods. Otherwise specify certs in `apiserver.servingCerts.{caCrt, serverCrt, serverKey}`.
            generate: true
            # CA certficate used by serving certificate of Config Syncer server.
            caCrt: ""
            # Serving certficate used by Config Syncer server.
            serverCrt: ""
            # Private key for the serving certificate used by Config Syncer server.
            serverKey: ""

        config:
          # Set cluster-name to something meaningful to you, say, prod, prod-us-east, qa, etc.
          # so that you can distinguish notifications sent by config-syncer
          clusterName: ${CONFIG_INFRA_CLUSTER}
          # If set, configmaps and secrets from only this namespace will be synced
          # Don't use this feature - use the following annotation instead:
          #### Sync certificate to matching namespaces
          ### secretTemplate:
          ###   annotations:
          ###     kubed.appscode.com/sync: ""
          configSourceNamespace: ""
          
          # kubeconfig file content for configmap and secret syncer
          kubeconfigContent: ""
        #  additionalOptions:
        #    - --authentication-skip-lookup


```