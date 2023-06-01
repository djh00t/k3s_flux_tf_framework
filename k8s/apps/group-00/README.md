# GROUP-00

* Application Class: Core (strongly recommended)

### Description

This group of applications are core/global functionality and variables which are used to create the base environment required for all other applications to function correctly. While some of these applications might be optional in your environment, most of them are important to understand before disabling them.

### Directory Structure

This application contains 3 subdirectories and 2 files:

* **README.md** \- This README file\.
* **cluster-config** \- Global variables and configurations that are shared between multiple applications\.
* **hostpath-provisioner** \- A storage provisioner that allows PV's to be created in specific locations to enable ongong persistence\, even after a PV has been destroyed and recreated\.
* **local-path** \- Standard local\-path provisioner with installation specific modifications to be defined like physical location of storage\.

**Please note:** *If you add or remove files - please remember to alter the kustomization.yaml file that refers to them and this README.md file. If you are adding or removing items in the config directory you will need to modify the app/kustomization.yaml file.*

```
.
├── README.md
├── cluster-config
├── hostpath-provisioner
├── kustomization.yaml
└── local-path
```

To enable or disable this group, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.