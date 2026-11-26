---
layout: post
title: "From Brownfield Vault to Terraform: Reviewing an Agentic Codifier"
date: 2026-11-26 09:39:53 +0000
categories: [terraform, vault]
tags: [hashicorp-vault, terraform, brownfield, infrastructure-as-code, agent-skills, platform-engineering]
---

Most Vault installations do not begin life as Terraform projects. They grow
the usual way: a bit of clicking in the UI, a script here, an emergency fix
there, and somebody who knows how it all works moving on to a different
project at exactly the wrong moment.

Eventually someone asks for a proper, reviewable baseline. That is when the
fun starts. The cluster may contain namespaces, policies, auth methods,
identity relationships, quotas, and secrets engines, but nobody has described
the whole thing in one place. The documentation is usually a mixture of
memory, screenshots, and a shell history entry called `final-fix-2`.

The [vault-agentic-codifier](https://github.com/abuxton/vault-agentic-codifier)
is an attempt to deal with that brownfield problem. It surveys a live
HashiCorp Vault Enterprise cluster, records what it finds, and generates
Terraform HCL with import blocks so the existing configuration can be adopted
without casually rebuilding it.

The project has now completed Stage 1 and is public under the Apache-2.0
licence. That makes this a useful point to review what it actually proves,
what it sensibly refuses to claim, and where the next specifications are
heading.

## Exporting resources is the easy bit

An exporter can list objects. Brownfield codification needs to understand
relationships and ownership as well.

A namespace determines the context in which a policy or auth mount exists. An
AppRole refers to policies. Identity groups connect people or services to
access. Mount tuning affects the Terraform plan. Import IDs are often relative
to a provider namespace rather than the full path a person sees in the Vault
UI. A generated file can be perfectly valid HCL and still adopt the wrong
object, or quietly plan to replace something that was already working.

I have spent enough time looking at infrastructure that "the file parses" is
not a particularly exciting definition of success. The more useful question
is whether the generated Terraform represents the existing cluster and can
prove that it will leave that cluster alone.

## Four phases, four kinds of work

The repository describes four phases:

1. **Discovery** walks namespaces and reads mounts, policies, identities, auth
   methods, and system settings.
2. **Research** correlates those raw responses into domain and resource maps.
3. **Codification** turns the findings into Terraform HCL and import blocks.
4. **Validation** checks formatting, provider behaviour, zero-diff plans,
   idempotence, audit logs, and secret handling.

The work is split between four roles: Vault Expert, Solution Architect, SRE,
and Technical Writer. Those roles are implemented as agent skills rather than
as a large Python application. Discovery uses the Vault CLI, `curl`, and
`jq`; codification emits Terraform; validation uses Terraform and shell
checks.

That is a good fit for the problem. It keeps the important work visible as
commands, files, evidence, and decisions. There is no impressive runtime
diagram to admire while the actual behaviour hides behind three layers of
abstraction. Sometimes boring is exactly what you want from infrastructure.

The OpenSpec artefacts provide the contract. The original
[proposal](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-brownfield-research/proposal.md),
[specification](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-brownfield-research/specs.md),
[design](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-brownfield-research/design.md),
and [task list](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-brownfield-research/tasks.md)
make the acceptance criteria visible before implementation starts.

That matters because "generate Terraform" is not a sufficient definition of
done. It is barely the start of the conversation.

## The three-layer state model

Generated Terraform is divided into three state layers:

| Layer | Responsibility |
| --- | --- |
| `admin/` | Root configuration, audit devices, quotas, the admin namespace, and bootstrap objects |
| `namespaces/` | The organisational namespace tree and its platform-level relationships |
| `seed/` | Tenant mounts, policies, roles, and provider aliases |

The layout follows lifecycle and blast-radius boundaries. Each Vault resource
type has one owning capability. A policy generator owns policies; an auth
generator owns auth mounts and roles; a team generator owns identity objects.
Other capabilities reference those resources instead of declaring duplicates.

That ownership rule is easy to underestimate. Terraform will quite happily
allow several files to describe the same remote object. It only becomes
interesting when the plan wants to replace something on a Friday afternoon.
The project makes ownership a validation rule and checks that resources have
provenance headers, unique labels, and one import block.

Provider aliases handle namespace targeting. The project rejected the
resource-level `namespace` argument for this workflow because it made import
blocks plan replacements in the provider version under test. That is exactly
the sort of detail that looks tidy in a design document and then bites you
when the plan is finally allowed out of its cage.

## Read-only is a claim with evidence behind it

The safest feature in the project is not the generated HCL. It is the boundary
around discovery.

The exporter identity is deliberately separate from the root token. Discovery
refuses a root-policy token, requires an audit device, and is restricted to
read and list operations. The generated output never includes KV data, AppRole
secret IDs, tokens, private keys, or other credential values. A generator exits
when a payload contains a credential field rather than quietly producing a
plausible-looking file and hoping nobody notices.

The synthetic Vault Enterprise harness supplies the test environment. The
reported final run used 221 exporter-token requests, all `read` or `list`, and
the audit log showed no requests to secret data, metadata, role IDs, secret
IDs, the licence, or root configuration. A live exporter write attempt
returned 403 and appeared in the audit verification.

That is useful evidence. It is not a magic force field around a production
cluster. A real deployment would still need to review the exporter policy,
protect the Terraform state, choose a remote backend, and decide how to handle
objects the provider cannot import. The project is proving a boundary, not
promising that infrastructure has stopped being dangerous.

## What Stage 1 proves

The Stage 1 baseline is documented as complete at the current public
repository snapshot, [`76bfcd8`](https://github.com/abuxton/vault-agentic-codifier/commit/76bfcd88b92065022fd73226fedb2dad2a8fd02a),
on 26 November 2026.

The repository reports:

- seven discovery capabilities and seven codification generators;
- assembly and ownership checks across the generated layers;
- static formatting, validation, and `tflint` checks;
- scratch-state import and zero-diff planning;
- read-only and no-secrets verification;
- edge-case variants for restricted access, empty clusters, OIDC, userpass,
  PKI, database mounts, nested namespaces, duplicate policies, and dangling
  policy references;
- byte-identical reruns for discovery and generation;
- a Waza review in which all 23 skills are structurally ready;
- a traceability matrix mapping 52 capability criteria and 7 common criteria
  to implementation tasks and checks.

The final `make codify-test` result is recorded as passing. The harness plan
contains 31 imports in `admin/`, 3 in `namespaces/`, and 18 in `seed/`, with
zero resources to add, change, or destroy in each layer. The self-test catches
12 of 12 injected verification faults.

This is meaningful evidence. The project can turn a known brownfield fixture
into a reviewed, import-oriented Terraform representation without changing
the fixture. That is a much better result than producing a large directory of
HCL and asking everyone to admire the formatting.

It still does not show that every production Vault can be codified.

## The gaps are part of the result

The traceability document is unusually direct about its gaps. Sentinel EGP
and RGP policies, MFA, replication, and several auth and secrets-engine
configurations are not exercised against the Stage 1 harness. Methods other
than AppRole and engines other than KV v2 are generally emitted as mounts and
listed for manual review. A real cluster has not yet been reviewed.

There is also a documentation lesson. `HANDOFF.md`, the task list, and the
traceability matrix record all 34 Stage 1 tasks as complete, while
`STATUS_REPORT.md` still contains an older task table and head reference.
That discrepancy does not invalidate the code, but it does show why a
generated status report needs the same review discipline as generated
Terraform.

The fair description is a validated research and internal migration
accelerator. It is not yet a turnkey production migration product, and
nobody should point it at production simply because the test plan came back
empty. I have seen enough empty plans to know they can be either reassuring
or the first warning sign.

## Stage 2: widening the capability slice

The new
[Stage 2 proposal](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-codifier-stage-2/proposal.md)
turns the Stage 1 limits into a concrete roadmap. At the time of this review,
the change is specified but not started.

Stage 2 adds five capabilities:

- **Sentinel policies:** discover EGP and RGP policies and preserve their
  source text.
- **MFA:** discover MFA methods and login enforcement without reading TOTP
  seeds, QR codes, or generated secrets.
- **Auth method configuration:** move beyond mount-only output for LDAP,
  Kubernetes, AWS, cert, token roles, and JWT/OIDC outside `admin`.
- **Secrets-engine configuration:** cover a bounded slice of PKI, database,
  AWS, transit, and SSH configuration without emitting keys or credentials.
- **Skill evaluations:** test whether agents follow the skills, using happy
  paths, stop conditions, deterministic graders, and a baseline without the
  skills.

The design is careful about scope. It does not claim complete Vault coverage.
It uses committed harness fixtures where they are stable, throwaway variants
where they would make the harness unwieldy, and a real model executor only
after explicit approval for cost. It also introduces new regression and
fixture-isolation criteria so that broader capability does not quietly break
the Stage 1 guarantees.

The distinction between `make codify-test` and the proposed eval suite is
important. `codify-test` measures generated output: HCL validity, zero diff,
secret handling, read-only behaviour, idempotence, naming, and provenance.
The eval suite would measure agent behaviour. A mock executor can test the eval
harness; it cannot establish that an agent follows the skills in practice.

That last distinction is worth keeping. A test harness can tell you whether
the harness works. It cannot grant an agent good judgement by administrative
fiat, sadly.

## Remote Review: the missing production-shaped test

The separate
[Remote Review proposal](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-codifier-remote-review/proposal.md)
addresses the largest remaining evidence gap: Stage 1 tests only the cluster
its authors built.

The proposed CAP-013 workflow requires written cluster-owner approval,
a purpose-built exporter identity, an explicit remote opt-in and address
allow-list, TLS verification, and output outside the public repository. It
would record only sanitised counts and error classes. Names, hosts, paths,
policy text, IDs, generated Terraform, and raw payloads would stay outside
the repository. A Terraform plan against the real cluster would require a
second approval and a scratch state; `apply` is out of scope.

That separation is a good design decision. Stage 2 asks whether the codifier
can represent more Vault features. Remote Review asks whether its assumptions
survive contact with a cluster it did not create. Mixing those questions would
make failures harder to interpret and would increase the risk of leaking
someone else's infrastructure into a public repository. It would also make
the post-incident explanation rather more entertaining than anybody wants.

## Verdict

The project is most interesting as a worked example of how to make an agentic
infrastructure workflow reviewable.

It constrains discovery, assigns ownership, records provider decisions,
generates reproducible output, and tests the result against a synthetic
environment. It also documents what the harness cannot prove and proposes
separate work for capability breadth, agent behaviour, and real-cluster
validation.

That is a better foundation than claiming an agent can safely export Vault to
Terraform because one generated plan happened to be empty. The remaining work
is substantial, but it is named: verify provider behaviour, add fixtures,
extend the generators, run approved evals, and perform a sanitised remote
review.

For teams with a brownfield Vault problem, Stage 1 is worth studying as a
migration accelerator and a set of design patterns. It should not be treated
as permission to point an unreviewed generator at production. The useful
lesson is the boundary around the automation: read-only credentials, explicit
ownership, import-only plans, auditable checks, and a written account of what
has not yet been tested.

That is not as glamorous as a button marked **Migrate Everything**, but it is
considerably more likely to leave you with the same number of namespaces you
started with.

## Further reading

- [Project README](https://github.com/abuxton/vault-agentic-codifier)
- [Usage guide](https://github.com/abuxton/vault-agentic-codifier/blob/main/docs/usage-guide.md)
- [Traceability matrix](https://github.com/abuxton/vault-agentic-codifier/blob/main/docs/traceability.md)
- [Stage 1 handoff](https://github.com/abuxton/vault-agentic-codifier/blob/main/HANDOFF.md)
- [Stage 2 tasks](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-codifier-stage-2/tasks.md)
- [Remote Review tasks](https://github.com/abuxton/vault-agentic-codifier/blob/main/openspec/changes/vault-codifier-remote-review/tasks.md)

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
