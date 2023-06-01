# Config Syncer

* Application GitHub: [github.com/kubeops/config-syncer](https://github.com/kubeops/config-syncer)
* Application Helm Repository: [AppsCode](https://charts.appscode.com/stable/)
* Application Class: Core (strongly recommended)

### Description

*From application GitHub description.*

> Config Syncer by AppsCode keeps ConfigMaps and Secrets synchronized across namespaces and/or clusters.

We use Config Syncer to sync configurations and secrets between namespaces.

### Directory Structure

This application contains 2 subdirectories and 3 files:

* **README.md** \- This README file\.
* **app** \- The core application/release files\. Under most circumstances\, you shouldn't need to worry about these configurations\.
* **config** \- This is where most commonly altered configuration files\, configmaps and secrets live\.
* **ks-config-syncer.yaml** \- The kustomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.

**Please note:** *If you add or remove files - please remember to alter the kustomization.yaml file that refers to them. If you are adding or removing files in the config directory you will need to modify the app/kustomization.yaml file.*

```
├── README.md
├── app
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   ├── release.yaml
│   └── repo.yaml
├── config
│   └── config-syncer.configmap.yaml
├── ks-config-syncer.yaml
└── kustomization.yaml
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.