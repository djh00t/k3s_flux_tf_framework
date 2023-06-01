# GROUP-02

* Application Class: Pre-requisites for other applications (As required)

### Description

This group of applications are background services and applications that support other applications. ie. Databases which maintain state or collect data for other applications.

### Directory Structure

This application contains 2 subdirectories and 2 files:

* **README.md** \- This README file\.
* **cloudnative-pg** \- CloudNativePG is a Kubernetes operator that covers the full lifecycle of a PostgreSQL database cluster with a primary/standby architecture, using native streaming replication.
* **clickhouse** \- ClickHouse is an open-source column-oriented database management system that allows generating analytical data reports in real time. Its fast and has many interesting features like MySQL engine, Kafka interface, replication, sharding, etc.
* **cockroachdb** \- CockroachDB - the open source, cloud-native distributed SQL database.
* **kustomization.yaml** \- The kustomization file for this application group\.

**Please note:** *If you add or remove files - please remember to alter the kustomization.yaml file that refers to them and this README.md file. If you are adding or removing items in the config directory you will need to modify the appropriate kustomization.yaml file.*

```
.
├── README.md
├── cloudnative-pg
├── cockroachdb
└── kustomization.yaml
```

To enable or disable this group, uncomment it in the ./k8s/apps/kustomization.yaml file and push your change to your git repository. Flux will poll your git repo every minute looking for changes and you will see the application appear in your list of flux managed packages by executing `flux get all -A`.
