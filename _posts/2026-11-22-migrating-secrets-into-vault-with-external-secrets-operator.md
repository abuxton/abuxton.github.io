---
layout: post
title: "Migrating Secrets into Vault with External Secrets Operator"
date: 2026-11-22 09:00:00 +0000
categories: [development, security]
tags: [vault, hashicorp, external-secrets, eso, kubernetes, secrets-management, migration, pushsecret, kind, taskfile]
---

Every secrets migration I have seen starts the same way. Someone writes a
script. It reads secrets from the old platform, writes them to a file or a
shell variable, and loops over them into the new one. It works on the day. Then
you notice the export sitting in a laptop's home directory, or in a CI
workspace, or in the shell history of whoever ran it last.

The migration is meant to improve how you handle secrets. A script that
scatters them on the way is a poor start.

I wanted to see whether the tool many teams already run in Kubernetes could do
the job instead. The result is
[abuxton/vault-migrate](https://github.com/abuxton/vault-migrate): a local,
disposable demo that moves secrets from a simulated legacy platform into
HashiCorp Vault using the [External Secrets Operator](https://external-secrets.io/latest/)
(ESO). The pattern applies to Vault Enterprise and HCP Vault as much as to the
in-cluster dev instance used in the demo.

The migration process also needs to fit the Vault design, not just move values.
A platform team might establish Vault namespaces and secrets engine mounts for
different parts of the organisation, with policies defining who can write to
each path. A reusable pull-and-push process can follow that design: the same
approach can be adapted for each source and destination, rather than asking
one team to run a single migration for everyone.

[HashiCorp's Vault organizational concepts guide](https://developer.hashicorp.com/validated-designs/vault/administration-guide/vault-organizational-concepts)
provides a useful starting point for that design. For Vault Enterprise and
HCP Vault Dedicated, it recommends tenant namespaces under an `admin`
namespace, with sub-namespaces that can represent applications or
environments. The namespace structure depends on the organisation; it is
not a substitute for policies that grant each team and workload only the
access it needs. In HCP Vault Dedicated, the root namespace is reserved for
the HCP control plane; for self-managed Enterprise, the guide recommends
reserving it for Vault operators.

That makes it possible to separate core platform secrets from product and
development team secrets. The platform team can migrate the shared services it
owns and provide guidance on destination paths, access, review and cutover.
Product teams can then migrate and validate their own secrets within those
boundaries, taking responsibility for their applications without needing
access to another team's secrets.

The guide also recommends managing Vault configuration through reviewed,
version-controlled infrastructure as code, with reusable modules for
application teams. For a migration, agree the destination namespace, mount,
policies and owners before moving values; test the configuration in a separate
Vault environment, then review the cutover and rollback plan with the
application team. Keep secret values out of Git, and protect any automation
state or logs that might contain them.

The demo shows the mechanics with one source and one Vault mount; it does not
implement that multi-team design. In practice, each migration needs its own
approved source and destination, appropriately scoped Kubernetes and Vault
permissions, and an agreed way to verify the result and retire the old
credentials. Vault namespaces and mounts help organise that work, but access
policies and the team's management processes enforce the boundaries.

## The pattern: pull, then push

Most people meet ESO through `ExternalSecret`: read from an external provider,
write a Kubernetes `Secret`. That is the **pull**.

ESO also has [`PushSecret`](https://external-secrets.io/latest/guides/pushsecrets/),
which goes the other way: take a Kubernetes `Secret` and write it to a
provider. That is the **push**.

Put them together and you have a migration:

1. An `ExternalSecret` pulls from the source platform.
2. A `PushSecret` writes the result into Vault.

No new tool, no new DSL. Everything is a Kubernetes resource you can review,
diff and keep in Git.

## The stores

ESO describes each side of the migration with a `ClusterSecretStore`. The
source store uses ESO's Kubernetes provider to read from a `legacy-platform`
namespace, using a dedicated read-only ServiceAccount:

```yaml
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: source-k8s
spec:
  provider:
    kubernetes:
      remoteNamespace: legacy-platform
      auth:
        serviceAccount:
          name: eso-source-reader
          namespace: legacy-platform
```

In a real migration the source would be whatever you are moving away from:
another cloud secret manager, another operator, or secrets synced from CI.
ESO has [providers](https://external-secrets.io/latest/provider/aws-secrets-manager/)
for many of them, and that is the part that makes this reusable. Change the
store, keep the pattern.

The target store points at Vault, using Kubernetes auth with ESO's own
ServiceAccount rather than a long-lived token:

```yaml
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault.vault.svc.cluster.local:8200"
      path: "migration"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "eso-migration"
          serviceAccountRef:
            name: "external-secrets"
            namespace: "external-secrets"
```

For Vault Enterprise or HCP Vault you would change the `server`, add the
Vault namespace, and scope the role and policy to the KV path you are
migrating into.

## Step one: pull and template

The `ExternalSecret` reads each value from the legacy secret and builds a
local Kubernetes `Secret`. I use the template to add a marker, so it is
obvious later which secrets have been through the pipeline:

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: migrated-app-credentials
  namespace: eso-demo
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: source-k8s
  target:
    name: migrated-app-credentials
    creationPolicy: Owner
    template:
      engineVersion: v2
      metadata:
        labels:
          migrated-from: legacy-platform
          migrated-to: vault
      data:
        username: "{{ .username }}"
        password: "{{ .password }}"
        connection: "{{ .connection }}"
        migrated_at: "{{ now | date \"2006-01-02T15:04:05Z07:00\" }}"
  data:
    - secretKey: username
      remoteRef:
        key: legacy-app-credentials
        property: username
    # password and connection follow the same shape
```

Templating is where a migration usually gets interesting. You can rename keys,
reshape a connection string, or add metadata without a transformation script.

## Step two: push into Vault

The `PushSecret` selects that Kubernetes `Secret` and maps each key to a path
and property in Vault:

```yaml
apiVersion: external-secrets.io/v1alpha1
kind: PushSecret
metadata:
  name: app-credentials-to-vault
  namespace: eso-demo
spec:
  refreshInterval: 1h
  secretStoreRefs:
    - kind: ClusterSecretStore
      name: vault-backend
  selector:
    secret:
      name: migrated-app-credentials
  data:
    - match:
        secretKey: username
        remoteRef:
          remoteKey: apps/eso-demo/app-credentials
          property: username
    # password, connection and migrated_at follow the same shape
```

Read the two resources side by side and they mirror each other: `remoteRef`,
store references, `refreshInterval`, templating. If you already run ESO, you
already know how to read this. That matters when you are teaching a team or
handing the migration to people who will own it afterwards. There is almost
nothing new to learn.

## Running it

The demo runs in a local [Kind](https://kind.sigs.k8s.io/) cluster,
orchestrated with [Taskfile](https://taskfile.dev/). It needs Docker, kind,
kubectl, helm and go-task:

```bash
task up                # cluster, ESO, Vault, source secrets, migrate, validate
task migrate:validate  # read the migrated secret back out of Vault
task down              # remove everything
```

The validation commands print the migrated values to the terminal. They are
safe to inspect here because the demo uses fake secrets; do not use this
validation approach for production credentials or in shared CI logs.

This walkthrough uses a local Kubernetes cluster and assumes you are already
comfortable operating Kubernetes and Kind. It is not a recommended starting
point for handling real secrets if you are unfamiliar with local clusters:
Kubernetes `Secret` data is stored in the cluster state, which for a local
cluster is backed by data on your machine. Tearing down the cluster does not
guarantee secure deletion of every copy. Use fake values for the demo, and
only handle real credentials locally if you understand where cluster data,
backups and logs may persist.

`task up` creates the cluster, installs ESO and an in-cluster Vault, publishes
the fake legacy secrets, registers both stores, runs the pull and push, and
reads the result back from Vault. The
[migration walkthrough](https://github.com/abuxton/vault-migrate/blob/main/docs/migration-walkthrough.md)
in the repo explains each stage. There is also a bonus example using ESO
generators and templating, independent of the migration.

The migration mechanism uses Kubernetes, but the applications consuming the
secrets do not have to run there. Once the values are in Vault, an application
can use its usual Vault integration whether it is deployed on Kubernetes or
elsewhere. This is worth considering when applications already integrate with
an external secret service, even if Kubernetes is not part of their deployment
platform; the demo is a way to explore the migration approach, not a reason to
introduce Kubernetes just to use it.

## Following a secret through the migration

I like this approach because it avoids a deliberate export to a file on an
operator's laptop or in a CI workspace. That removes one place where an
unattended copy could be left behind. It does not mean the secret never reaches
disk, or that deleting a container erases every copy.

Consider the demo's `legacy-app-credentials`. It starts as a Kubernetes
`Secret` in `legacy-platform`. ESO's source ServiceAccount needs permission to
read it; people and workloads without that need should not have access. The
`ExternalSecret` then creates `migrated-app-credentials` in `eso-demo`. That
intermediate `Secret` can persist in etcd and backups, so restrict access with
RBAC and protect both etcd and its backups, including encryption at rest.

Finally, the `PushSecret` writes the values to Vault at
`migration/apps/eso-demo/app-credentials`. The demo uses Kubernetes auth for
ESO rather than a static Vault token. In a real migration, restrict the Vault
role and policy to the destination paths the team needs, and protect the
ServiceAccount credentials used to authenticate.

The Kind cluster and containers in the demo are disposable. `task down`
removes the demo resources and cluster, but it does not guarantee secure
deletion of copies in backups, logs or underlying storage. Production
environments need their own retention and cleanup plan.

<figure>
  <a href="https://xkcd.com/2543/">
    <img src="https://imgs.xkcd.com/comics/never_told_anyone.png"
         alt="XKCD comic 2543, Never Told Anyone"
         style="max-width: 100%; height: auto;">
  </a>
  <figcaption>
    <a href="https://xkcd.com/2543/">XKCD 2543: Never Told Anyone</a> by Randall Munroe,
    <a href="https://creativecommons.org/licenses/by-nc/2.5/">CC BY-NC 2.5</a>.
  </figcaption>
</figure>

### Validate without exposing values

The demo reads the Vault secret back to the terminal. For real credentials,
check the ESO resources' status and use a controlled application or test to
confirm the destination works without printing values. A ready status alone
does not prove the right values reached the right consumer. Keep any comparison
inside a trusted environment and report a pass or failure, not the secrets.

Check what ESO controller logs, events and metrics record at the configured log
level. Review Vault audit logging too: protect access to logs, decide where
they are shipped and how long they are kept, and check the effect of your
audit configuration before migrating. Avoid putting values into terminal
output, CI logs or diagnostic captures.

Once consumers have moved and validation is complete, stop reconciliation
deliberately and remove temporary access and intermediate secrets. Check the
`ExternalSecret` and `PushSecret` ownership and deletion settings first, so
cleanup does not remove a Vault secret you intend to keep. Account for retained
backups and rotate or retire the old credentials according to your policy.

## What the ESO threat model says

ESO publishes its own [threat model](https://external-secrets.io/latest/guides/threat-model/).
It classifies the data as "Critical" and the highest risk impact as
"organisation takeover", which is the right level of seriousness for a
migration. A few threats stand out:

- **T03: unauthorised access to cluster secrets.** The controller can read and
  write secrets across namespaces, so its ServiceAccount token matters.
- **T04: provider credentials.** Over-broad Vault credentials could mean
  organisation-wide impact. Scope the policy tightly.
- **T05: data exfiltration through malicious resources.** A crafted
  `ExternalSecret`, `PushSecret` or `ClusterSecretStore` could copy data to the
  wrong namespace or provider. Anyone who can write these resources needs to be
  trusted.

The controls it lists map neatly to the migration:

- **Least-privilege RBAC** for ESO, for users, and for the Vault policy.
  The repo's `k8s/source/rbac.yaml` and `vault/configure-vault.sh` show a
  narrow starting point.
- **Policy enforcement** with Kyverno or OPA to restrict providers, auth
  methods and `namespaceSelector` use.
- **Network policies** and **provider access policies**, such as private
  endpoints for HCP Vault or Vault Enterprise.
- **Disable unused CRDs.** This pattern needs `PushSecret`, but you can turn it
  off again once the migration is done.

The threat model is honest that ESO does not ship pre-packaged network
policies or policy-engine rules. Those controls are yours to write. What the
approach gives you is a declarative, reviewable migration that can avoid
unnecessary exports. How long copies and credentials remain accessible depends
on the environment and the cleanup process.

## Caveats

- Vault in the demo runs in **dev mode**: unsealed, in-memory, with a fixed root
  token. It is for local use only. Do not copy it into production.
- `PushSecret` is `v1alpha1` in the repo's manifests, so check the current ESO
  docs for its status before you rely on it.
- Everything under `k8s/source/` is fake demo data. Do not commit real
  secrets.
- Mind `refreshInterval`. Both resources keep reconciling, so decide when the
  migration is finished and stop it deliberately.

## Try it

Clone [abuxton/vault-migrate](https://github.com/abuxton/vault-migrate), run
`task up`, and read the manifests under `k8s/migrate/`. Then swap the source
store for something you actually use. If you already know ESO, the surprising
part is how little else there is to learn.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
