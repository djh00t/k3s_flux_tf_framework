# config directory

* Application GitHub: [github.com/stakater/Reloader](https://github.com/stakater/Reloader)

### Description

This directory contains files that are used to configure Reloader.

### Directory Structure

This application contains 2 files by default:

* **README.md** - This README file.
* **configmap.yaml** - This file contains the configuration for Reloader.

**Please note:** <em>If you are adding or removing files in the config directory you will need to **modify the kustomization.yaml file in the apps directory** to include or exclude the files you wish to use.</em>

```
├── README.md
└── configmap.yaml
```

## Example file formats

### configmap.yaml

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: reloader-helm-chart-value-overrides
  namespace: reloader
data:
  values.yaml: |-
    # Generated from deployments/kubernetes/templates/chart/values.yaml.tmpl
    global:
      ## Reference to one or more secrets to be used when pulling images
      ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
      ##
      imagePullSecrets: []

    kubernetes:
      host: https://kubernetes.default

    nameOverride: ""
    fullnameOverride: ""

    reloader:
      isArgoRollouts: false
      isOpenshift: false
      ignoreSecrets: false
      ignoreConfigMaps: false
      reloadOnCreate: false
      syncAfterRestart: false
      reloadStrategy: default # Set to default, env-vars or annotations
      ignoreNamespaces: "" # Comma separated list of namespaces to ignore
      namespaceSelector: "" # Comma separated list of k8s label selectors for namespaces selection
      resourceLabelSelector: "" # Comma separated list of k8s label selectors for configmap/secret selection
      logFormat: "" #json
      watchGlobally: true
      # Set to true to enable leadership election allowing you to run multiple replicas
      enableHA: false
      # Set to true if you have a pod security policy that enforces readOnlyRootFilesystem
      readOnlyRootFileSystem: false
      legacy:
        rbac: false
      matchLabels: {}
      deployment:
        # If you wish to run multiple replicas set reloader.enableHA = true
        replicas: 1
        nodeSelector:
        # cloud.google.com/gke-nodepool: default-pool

        # An affinity stanza to be applied to the Deployment.
        # Example:
        #   affinity:
        #     nodeAffinity:
        #       requiredDuringSchedulingIgnoredDuringExecution:
        #         nodeSelectorTerms:
        #         - matchExpressions:
        #           - key: "node-role.kubernetes.io/infra-worker"
        #             operator: "Exists"
        affinity: {}

        securityContext:
          runAsNonRoot: true
          runAsUser: 65534

        containerSecurityContext: {}
          # capabilities:
          #   drop:
          #     - ALL
          # allowPrivilegeEscalation: false
          # readOnlyRootFilesystem: true

        # A list of tolerations to be applied to the Deployment.
        # Example:
        #   tolerations:
        #   - key: "node-role.kubernetes.io/infra-worker"
        #     operator: "Exists"
        #     effect: "NoSchedule"
        tolerations: []

        # Topology spread constraints for pod assignment
        # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
        # Example:
        # topologySpreadConstraints:
        #   - maxSkew: 1
        #     topologyKey: zone
        #     whenUnsatisfiable: DoNotSchedule
        #     labelSelector:
        #       matchLabels:
        #         app: my-app
        topologySpreadConstraints: []

        annotations: {}
        labels:
          provider: stakater
          group: com.stakater.platform
          version: v1.0.24
        image:
          name: ghcr.io/stakater/reloader
          tag: v1.0.24
          pullPolicy: IfNotPresent
        # Support for extra environment variables.
        env:
          # Open supports Key value pair as environment variables.
          open:
          # secret supports Key value pair as environment variables. It gets the values based on keys from default reloader secret if any.
          secret:
          #  ALERT_ON_RELOAD: <"true"|"false">
          #  ALERT_SINK: <"slack"> # By default it will be a raw text based webhook
          #  ALERT_WEBHOOK_URL: <"webhook_url">
          #  ALERT_ADDITIONAL_INFO: <"Additional Info like Cluster Name if needed">
          # field supports Key value pair as environment variables. It gets the values from other fields of pod.
          field:
          # existing secret, you can specify multiple existing secrets, for each
          # specify the env var name followed by the key in existing secret that
          # will be used to populate the env var
          existing:
          #  existing_secret_name:
          #    ALERT_ON_RELOAD: alert_on_reload_key
          #    ALERT_SINK: alert_sink_key
          #    ALERT_WEBHOOK_URL: alert_webhook_key
          #    ALERT_ADDITIONAL_INFO: alert_additional_info_key

        # Liveness and readiness probe timeout values.
        livenessProbe: {}
        #  timeoutSeconds: 5
        #  failureThreshold: 5
        #  periodSeconds: 10
        #  successThreshold: 1
        readinessProbe: {}
        #  timeoutSeconds: 15
        #  failureThreshold: 5
        #  periodSeconds: 10
        #  successThreshold: 1

        # Specify resource requests/limits for the deployment.
        # Example:
        # resources:
        #   limits:
        #     cpu: "100m"
        #     memory: "512Mi"
        #   requests:
        #     cpu: "10m"
        #     memory: "128Mi"
        resources: {}
        pod:
          annotations: {}
        priorityClassName: ""
        # imagePullSecrets:
        #   - name: myregistrykey

      service: {}
        # labels: {}
        # annotations: {}
        # port: 9090

      rbac:
        enabled: true
        labels: {}
      # Service account config for the agent pods
      serviceAccount:
        # Specifies whether a ServiceAccount should be created
        create: true
        labels: {}
        annotations: {}
        # The name of the ServiceAccount to use.
        # If not set and create is true, a name is generated using the fullname template
        name:
      # Optional flags to pass to the Reloader entrypoint
      # Example:
      #   custom_annotations:
      #     configmap: "my.company.com/configmap"
      #     secret: "my.company.com/secret"
      custom_annotations: {}

      serviceMonitor:
        # Deprecated: Service monitor will be removed in future releases of reloader in favour of Pod monitor
        # Enabling this requires service to be enabled as well, or no endpoints will be found
        enabled: false
        # Set the namespace the ServiceMonitor should be deployed
        # namespace: monitoring

        # Fallback to the prometheus default unless specified
        # interval: 10s

        ## scheme: HTTP scheme to use for scraping. Can be used with `tlsConfig` for example if using istio mTLS.
        # scheme: ""

        ## tlsConfig: TLS configuration to use when scraping the endpoint. For example if using istio mTLS.
        ## Of type: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#tlsconfig
        # tlsConfig: {}

        # bearerTokenFile:
        # Fallback to the prometheus default unless specified
        # timeout: 30s

        ## Used to pass Labels that are used by the Prometheus installed in your cluster to select Service Monitors to work with
        ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
        labels: {}

        ## Used to pass annotations that are used by the Prometheus installed in your cluster to select Service Monitors to work with
        ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
        annotations: {}

        # Retain the job and instance labels of the metrics pushed to the Pushgateway
        # [Scraping Pushgateway](https://github.com/prometheus/pushgateway#configure-the-pushgateway-as-a-target-to-scrape)
        honorLabels: true

        ## Metric relabel configs to apply to samples before ingestion.
        ## [Metric Relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs)
        metricRelabelings: []
        # - action: keep
        #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
        #   sourceLabels: [__name__]

        ## Relabel configs to apply to samples before ingestion.
        ## [Relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config)
        relabelings: []
        # - sourceLabels: [__meta_kubernetes_pod_node_name]
        #   separator: ;
        #   regex: ^(.*)$
        #   targetLabel: nodename
        #   replacement: $1
        #   action: replace

        targetLabels: []

      podMonitor:
        enabled: false
        # Set the namespace the podMonitor should be deployed
        # namespace: monitoring

        # Fallback to the prometheus default unless specified
        # interval: 10s

        ## scheme: HTTP scheme to use for scraping. Can be used with `tlsConfig` for example if using istio mTLS.
        # scheme: ""

        ## tlsConfig: TLS configuration to use when scraping the endpoint. For example if using istio mTLS.
        ## Of type: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#tlsconfig
        # tlsConfig: {}

        # bearerTokenSecret:
        # Fallback to the prometheus default unless specified
        # timeout: 30s

        ## Used to pass Labels that are used by the Prometheus installed in your cluster to select Service Monitors to work with
        ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
        labels: {}

        ## Used to pass annotations that are used by the Prometheus installed in your cluster to select Service Monitors to work with
        ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
        annotations: {}

        # Retain the job and instance labels of the metrics pushed to the Pushgateway
        # [Scraping Pushgateway](https://github.com/prometheus/pushgateway#configure-the-pushgateway-as-a-target-to-scrape)
        honorLabels: true

        ## Metric relabel configs to apply to samples before ingestion.
        ## [Metric Relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs)
        metricRelabelings: []
        # - action: keep
        #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
        #   sourceLabels: [__name__]

        ## Relabel configs to apply to samples before ingestion.
        ## [Relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config)
        relabelings: []
        # - sourceLabels: [__meta_kubernetes_pod_node_name]
        #   separator: ;
        #   regex: ^(.*)$
        #   targetLabel: nodename
        #   replacement: $1
        #   action: replace

        podTargetLabels: []

      podDisruptionBudget:
        enabled: false
        # Set the minimum available replicas
        # minAvailable: 1
```