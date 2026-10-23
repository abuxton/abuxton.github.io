---
layout: post
title: "Building a DevOps / SRE Operator Toolkit with Do-Nothing Scripting"
date: 2026-10-23 11:13:11 +0000
categories: [development, sre]
tags: [devops, sre, bash, automation, github-gists, kubernetes, incident-response, runbooks]
---

There is a familiar first half-hour to a new engagement. You arrive at a
cluster or VM with a problem to investigate, then start reconstructing the
same diagnostic commands you used last week: `kubectl get events`, `kubectl
describe pod`, `journalctl -u`, DNS lookups, metadata requests, and a lot of
careful checking before you change anything.

The commands are not difficult. Remembering the right sequence under pressure
is the difficult part. Runbooks help, but prose still leaves the operator to
translate instructions into shell syntax in the moment.

I have been collecting that work into a set of small, standalone scripts. The
aim is not to replace an experienced operator. It is to give one a useful
starting point: a repeatable diagnostic path that is quick to share, inspect,
and adapt.

## Do-nothing scripting as a useful middle ground

The approach comes from Dan Slimmon's
[do-nothing scripting](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/).
The useful observation is that automation does not need to start by taking
control. A script that shows the next command, explains the step, and lets a
human decide whether to run it is already better than a document that makes
the operator remember the syntax and ordering.

The scripts in this collection use two modes:

- an automated mode for collecting diagnostics and producing a findings report
- a `--dry-run` mode that shows the intended commands and makes the operator
  step through the work deliberately

`--dry-run` is not a guarantee of safety. It improves visibility and gives the
operator a chance to check assumptions, but the environment, credentials,
permissions, and the script itself still need review. That distinction matters
most in a customer environment or an incident where a command with the wrong
scope can make a bad situation worse.

## The shape of the toolkit

The collection is deliberately split into small tools. A certificate checker
checks certificates. A Kubernetes event tool triages events. A database health
checker asks databases the questions an operator usually asks first. Keeping
the scripts narrow makes them easier to read and less likely to grow into an
unmaintainable incident-management framework.

There are four rough layers.

### Deployment validation

Before an application can be useful, its certificates, DNS, and deployment
baseline need to be sound. These scripts handle those first checks.

| Script | Purpose | Gist |
|---|---|---|
| `cert-validate.sh` | TLS expiry, chain, SANs, and OCSP checks | [G01](https://gist.github.com/abuxton/fd72026826032d7e132ae585f77e720e) |
| `dns-validate.sh` | DNS resolution, propagation, and record validation | [G02](https://gist.github.com/abuxton/75992e306ed4873c0b0d6f2078ca704d) |
| `vault-raft-deploy.sh` | HashiCorp Vault Raft cluster deployment workflow | [G03](https://gist.github.com/abuxton/62b55b0c7c059529bf2f43733ae9b0bc) |

### Debug and observability

Once a deployment exists, the operator needs to see inside it. This tier
covers service logs, containers, Kubernetes workloads and events, and images.

| Script | Purpose | Gist |
|---|---|---|
| `systemctl-debug.sh` | systemd service inspection and log triage | [G04](https://gist.github.com/abuxton/8c0be9adcd234b109af2e3e19caf7e5e) |
| `container-debug.sh` and `container-cleanup.sh` | Docker/Podman inspection and cleanup | [G05](https://gist.github.com/abuxton/e5a9fd0a5a699a8790e9ca57d4b33713) |
| `k8s-debug.sh`, `k8s-cleanup.sh`, and `k8s-workload.sh` | Kubernetes workload, namespace, and cleanup operations | [G06](https://gist.github.com/abuxton/42601fa08c63e742e7428d3924c9d05b) |
| `k8s-events.sh` | Kubernetes warning-event triage with watch mode | [G07](https://gist.github.com/abuxton/ebfacee337e2f600ddd2191cf02d8a89) |
| `k8s-logs.sh` | Multi-pod log collection, filtering, and file capture | [G08](https://gist.github.com/abuxton/e5bd0fde9b152066d3364951102fa748) |
| `container-registry.sh` | Local image inspection, tagging, and scanning | [G09](https://gist.github.com/abuxton/3a007a865ececaf2a4e61405f3690154) |

### Infrastructure operations

The next group is for routine work around certificates, network access, and
the services supporting an application.

| Script | Purpose | Gist |
|---|---|---|
| `tls-rotate.sh` | Certificate rotation by file swap or Kubernetes Secret update | [G10](https://gist.github.com/abuxton/3e195b344e694e75fb50d366a98f81a4) |
| `dns-failover.sh` | Resolver comparison, health checks, and failover simulation | [G11](https://gist.github.com/abuxton/4c0925a991c58fb9eb9f6e32440c8bdd) |
| `port-forward.sh` | Interactive `kubectl port-forward` management | [G12](https://gist.github.com/abuxton/4ffc703faa085709080641169aed18e6) |
| `ssh-tunnel.sh` | Bastion tunnel management with status checks | [G13](https://gist.github.com/abuxton/ab9a38a6cda3d32e87a53b421f540dea) |
| `db-healthcheck.sh` | Health checks for PostgreSQL, MySQL, Redis, and MongoDB | [G14](https://gist.github.com/abuxton/aa01d2feb36bad6a689aecf5f3b1abf1) |

### Incident response and bootstrap diagnostics

The final group helps when the work needs to be handed to another engineer, a
vendor, or a later post-incident review.

| Script | Purpose | Gist |
|---|---|---|
| `incident-capture.sh` | Kubernetes snapshot captured to a timestamped archive | [G15](https://gist.github.com/abuxton/68d977f847f812d89da0744c46cfce9c) |
| `metrics-check.sh` | Prometheus endpoint checks and stale-metric detection | [G16](https://gist.github.com/abuxton/e0113a1024c26b71000ff0add4ebae8e) |
| `cloud-init-debug.sh` | cloud-init and user-data diagnostics across common platforms | [G17](https://gist.github.com/abuxton/73cccdede381ec815be3d8f3899e1d28) |

## A few that earn their place quickly

`k8s-events.sh` starts with warning events because they are often the fastest
route to a usable lead. It sorts them by time, can narrow by reason such as
`BackOff`, `OOMKill`, `Evicted`, or `Failed`, and can remain in watch mode
while a workload changes. That replaces a command I have reassembled from
memory far too many times.

`incident-capture.sh` is aimed at the handover problem. It collects named
categories of cluster state and packages them into a timestamped archive. The
person reading the archive still needs judgement, but they no longer need to
start by asking what the cluster looked like several hours ago.

`cloud-init-debug.sh` deals with another frustrating class of failure: a VM
that booted but did not configure itself as expected. It checks the relevant
metadata and logs for AWS, GCP, Azure, VMware, and local systems, and can wait
for cloud-init to reach a terminal state. The important detail is that
bootstrapping differs across providers; detection is useful, but an explicit
override remains necessary for unusual images and networks.

## Why publish the scripts as Gists?

For this kind of tool, a Gist has an advantage that is easy to underestimate.
It is one URL. An engineer can open it in a browser, read a short README,
clone it, or pass the link to someone else without first navigating a larger
repository. That makes a Gist a good unit of sharing for a focused diagnostic
tool.

The scripts are self-contained on purpose. They favour standard shell tools
and the relevant platform CLI over shared libraries and installation steps.
They also try to detect the common choice--`kubectl` or `oc`, Docker or
Podman, one cloud provider or another--while exposing flags for cases where
the detected default is wrong. Diagnostic scripts report their findings in a
small ERROR/WARN/OK summary, and credentials stay in environment variables
rather than command-line flags where possible.

That convenience has limits. Gists have weaker discovery, access control,
issue tracking, and release management than a normal repository. A mutable
Gist URL also does not identify one immutable version of a script. For a
repeatable operational procedure, use a specific revision or commit, record
the version in the runbook, and review changes before adopting them.

The download workflow should be equally deliberate:

```bash
# Clone the selected Gist, then inspect its contents before running anything.
git clone https://gist.github.com/abuxton/fd72026826032d7e132ae585f77e720e.git cert-validate
less cert-validate/cert-validate.sh

# Start with the guided mode.
bash cert-validate/cert-validate.sh --dry-run
```

I would not treat a Gist as an exception to normal code review. The fact that
a script is small and easy to share is exactly why it needs to be readable.

## Gradual automation is still automation

The useful part of this approach is not that it turns runbooks into a magic
button. It gives the operator a better interface to the accumulated knowledge
behind a runbook: a sequence that can be inspected, run one step at a time,
or automated when the context is understood.

Small tools also age better. A script with one diagnostic responsibility can
grow an extra flag without changing its whole model. A script that tries to
own the entire incident workflow quickly becomes something nobody wants to
touch in the middle of an incident.

This collection will change as the environments it supports change. For now,
the Gists are a useful place to keep the tools small, visible, and easy to
use when the first question is simply: what should I check next?

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
