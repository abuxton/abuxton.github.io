---
layout: post
title: "Reusable Terraform Tasks and Explicit Model Routing"
date: 2026-10-18 09:00:00 +0000
categories: [ai, development]
tags: [terraform, platform-engineering, local-llm, model-routing, ai-agents]
---

Can a local-first coding agent help with infrastructure work without becoming
an unattended deployment system? This milestone defines small, repeatable
Terraform and platform-engineering tasks, then makes the model-routing decision
visible instead of letting an agent silently send work somewhere else.

The [companion repository at immutable revision
`d903014`](https://github.com/abuxton/local-llm-tooling-series/tree/d903014c73cf01a2dc50b16e6899a4ee5f49b433)
contains the preceding local baseline: a pinned Ollama runtime and model, a
Terraform sandbox, and validation and plan targets. That revision predates the
task definitions described here; it does not contain the reusable task files.
The prompts below are publishable templates for that next implementation, not
evidence that the companion repository has already added or run them.

## Tasks small enough to review

The useful unit is not “ask an agent to build our platform.” Each task has a
bounded input, permitted operations, and a result a person can verify.

| Task | Permitted input and work | Required output and checks |
| --- | --- | --- |
| Terraform change proposal | The provider-free sandbox and a named, non-production requirement. The agent may edit files and run formatting, validation, and a local plan. | A source diff, rationale, assumptions, and plan summary. `terraform fmt -check`, `terraform validate`, and the plan must succeed; no apply or destroy. |
| Platform runbook draft | A checked-in sample manifest or sanitized, static configuration. No cluster connection, credentials, live inventory, or client data. | A proposed runbook with prerequisites, read-only checks, rollback considerations, and uncertainties. A reviewer checks commands and scope against the supplied fixture. |

These are candidate task definitions, not completed benchmark results. Freeze
the input fixture, acceptance checks, and prompt revision before comparing
models; repeat each task from a clean checkout and retain failures as well as
successful runs. The baseline's Terraform sandbox is deliberately narrow: it
uses Terraform's built-in `terraform_data` resource, has no provider or remote
backend, and can validate and plan without an infrastructure target.

### Prompt template: Terraform proposal

```text
Task: Propose a change to the supplied non-production Terraform fixture.
Requirement: <one bounded requirement>
Allowed files: <explicit paths>
Allowed checks: terraform fmt -check, terraform validate, terraform plan
  using the repository's sandbox target.
Do not: use credentials, configure a provider or remote backend, run apply
  or destroy, or execute commands outside the listed checks.
Return: the source diff, rationale, assumptions, validation results, and a
  concise summary of the plan. If the requirement cannot be met safely, stop
  and explain why rather than broadening scope.
```

### Prompt template: platform runbook

```text
Task: Draft a runbook for the supplied static, sanitized platform fixture.
Scope: <one operational question>
Use only: the supplied files and read-only commands explicitly listed here:
  <commands>
Do not: connect to a cluster or service, change configuration, use secrets,
  or invent environment-specific facts.
Return: prerequisites, read-only checks, expected observations, escalation
  points, rollback considerations for a human operator, and uncertainties.
Mark every proposed state-changing command as requiring human approval.
```

Both templates deliberately constrain tools and data as well as the wording of
the task. Replace placeholders with synthetic, reviewed inputs. Never paste
credentials, personal or client data, private infrastructure details, or raw
operational logs into a prompt. A local endpoint does not make an agent private
by itself: editor telemetry, model downloads, tools, logs, source control, and
fallbacks can each create separate data paths.

## Route by policy, not by guesswork

For this experiment, **local** means the pinned local runtime in the baseline;
**cloud** means a separately selected and explicitly approved model API; and
**hybrid** means local-first with a visible, opt-in cloud comparison or
fallback. A model router must not choose a destination based on an opaque
quality guess.

| Decision boundary | Action |
| --- | --- |
| Input contains a credential, personal or client data, or private infrastructure detail | Exclude it from this experiment. Do not send it to either route. |
| Task is in the reviewed, synthetic corpus and can run against the local baseline | Start locally and record the model/runtime identity and elapsed time. |
| Local run meets the task's predeclared acceptance checks before its fixed deadline | Keep the local result; do not call the cloud model just to compare it. |
| Local run times out, the tool fails, or a required check fails | Record the failure. A person may authorize a cloud fallback only if the task is still eligible and the exact payload, provider, model, and applicable budget have been reviewed. No silent retry. |
| Cloud comparison is required by the evaluation protocol | Treat it as a separate, explicitly selected condition. Record the payload class, provider/model revision, and cost. |
| Any proposed change could affect infrastructure | Stop before the state-changing command. A human must review the complete source diff and Terraform plan before every infrastructure change. |

Set the local deadline and acceptance checks before the run, not after seeing
which model performed better. A failed local attempt followed by an approved
cloud attempt is one hybrid run: report the total elapsed time and both
attempts, not just the faster cloud response. The source design also defers
automatic quality-based routing because its decisions and data transfers would
need independent evaluation.

## Latency and cost are workload-specific

Local latency includes model loading, inference, and tool execution. It can
avoid a network round trip, but a large or quantized model competing for
machine memory may be slower or unavailable on a particular host. Cloud
latency includes network and provider queueing as well as inference. A fallback
adds the failed local attempt to that cloud time; it does not erase it.
Measure end-to-end wall time for the complete task, including validation and
human review, and report timeouts and retries.

Local inference is not automatically free. Report electricity only when it
was measured or estimate it with stated assumptions
(`measured kW × run hours × local tariff`); distinguish that variable cost
from hardware purchase or amortization. Cloud cost depends on the selected
provider's current rates, input and output tokens, and retries. Capture the
applicable rate and model at run time rather than presenting a timeless price.
Compare the costs that actually apply to the experiment, not an assumed
universal winner.

The baseline records a 48 GB Apple Silicon host profile, pinned runtime and
model artifacts, and a Terraform v1.13.5 sandbox. It is one reproducible
condition, not a claim about other machines, model sizes, or task mixes. Every
result should include hardware, runtime and model revisions, prompt/task
revisions, repetitions, latency, resource use where available, applicable
cost, and failure modes.

## Approval is the boundary

The sandbox exposes validation and plan targets, not apply or destroy targets.
That reduces the chance that an experiment becomes a deployment path; it does
not make an LLM-generated change safe. Before **every** infrastructure change,
a person must inspect the generated source diff and the full Terraform plan,
then explicitly approve the next state-changing command. An agent must not
approve its own work or run that command unattended. If the plan, inputs, or
intended target are unclear, stop.

This is consistent with Terraform's separation between planning changes and
applying them: a plan is review input, not approval. The non-production
fixture and its limits are documented in the companion repository's
[baseline record at the same immutable revision](https://github.com/abuxton/local-llm-tooling-series/blob/d903014c73cf01a2dc50b16e6899a4ee5f49b433/docs/baseline-environment.md).

## Sources

- [Terraform `plan` command](https://developer.hashicorp.com/terraform/cli/commands/plan),
  accessed 15 October 2026. Describes generating a proposed change plan.
- [Terraform `apply` command](https://developer.hashicorp.com/terraform/cli/commands/apply),
  accessed 15 October 2026. Describes applying proposed changes; this workflow
  intentionally does not automate that step.
- [Terraform `terraform_data` resource](https://developer.hashicorp.com/terraform/language/resources/terraform-data),
  accessed 15 October 2026. Documents the built-in resource used by the
  provider-free sandbox.
- [Awesome AI Model Routing](https://github.com/Not-Diamond/awesome-ai-model-routing),
  accessed 15 October 2026. A discovery catalogue for routing approaches, not
  evidence that a router is suitable for this task corpus.
- [Companion repository baseline at `d903014`](https://github.com/abuxton/local-llm-tooling-series/tree/d903014c73cf01a2dc50b16e6899a4ee5f49b433),
  accessed 15 October 2026. This is the immutable revision of the prior
  baseline; it does not yet include the reusable tasks in this article.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
