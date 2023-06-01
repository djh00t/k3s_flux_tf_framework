# Cert Manager

* Application GitHub: [github.com/cert-manager/cert-manager](https://github.com/cert-manager/cert-manager)
* Application Helm Repository: [Jetstack](https://charts.jetstack.io)
* Application Class: Core (strongly recommended)

### Description

*From application GitHub description.*

> cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
> It supports issuing certificates from a variety of sources, including Let's Encrypt (ACME), HashiCorp Vault, and Venafi TPP / TLS Protect Cloud, as well as local in-cluster issuance.
> cert-manager also ensures certificates remain valid and up to date, attempting to renew certificates at an appropriate time before expiry to reduce the risk of outages and remove toil.

We use cert manager to generate Letsencrypt certificates for applications published using the framework.

### Directory Structure

This application contains 3 subdirectories and 2 files:

* **README.md** \- This README file\.
* **app** \- The core application/release files\. Under most circumstances\, you shouldn't need to worry about these configurations\.
* **certs** \- This is where you store CRDs that define the certificates you want cert\-manager to provision\. A base configuration is kept in here that generates a wildcard certificate for your clusters infra\_domain and the cluster\. You can add more domains/hostnames to this configuration or you can create additional configuration files in here if you choose\.
* **config** \- This is where most commonly altered configuration files\, configmaps and secrets live\.
* **ks-cert-manager.yaml** \- The kuk8sstomization definition for this application\.
* **kustomization.yaml** \- Defines the files to include/exclude\.

**Please note:** *If you add or remove files - please remember to alter the kustomization.yaml file that refers to them. If you are adding or removing files in the config directory you will need to modify the app/kustomization.yaml file.*

```
├── app
├── certs
├── config
├── ks-cert-manager.yaml
└── kustomization.yaml
└── README.md
```

### Enabling/Disabling this application

To enable or disable this application, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.