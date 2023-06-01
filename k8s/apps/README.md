# Application Groups

Applications are broken into 4 groups. The lower the group ID, the earlier the application will be deployed. This is to ensure that pre-requisites are deployed before the applications that depend on them.

The 4 groups are:
* GROUP-00 - Prerequisites for base cluster
* GROUP-01 - Base cluster services & applications
* GROUP-02 - Pre-requisites for applications
* GROUP-03 - Applications

```
.
├── README.md
├── group-00
├── group-01
├── group-02
├── group-03
└── kustomization.yaml
```
