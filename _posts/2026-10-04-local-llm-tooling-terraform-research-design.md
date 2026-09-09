---
layout: post
title: "Local LLM Tooling for Terraform: Research and Design Decisions"
date: 2026-10-04 09:00:00 +0000
categories: [ai, development]
tags: [local-llm, terraform, platform-engineering, model-routing, reproducibility, ai-agents]
---

Can a local model help with Terraform and platform-engineering work without
turning an experiment into an unsafe infrastructure deployment path?

That is the question for this series. It is not an attempt to prove that local
models are private, cheaper, or equivalent to cloud models. Those claims
depend on the hardware, model revision, runtime, prompt data, network
configuration, and the work being measured.

The [companion repository](https://github.com/abuxton/local-llm-tooling-series/tree/e6853f034ee49a9bfdef94c2fd28b0f7b7713878)
contains the versioned design record for this article. It is deliberately a
design baseline, not a benchmark result.

## The decision: local first, explicit fallback

The proposed workflow sends eligible, non-sensitive tasks to an
OpenAI-compatible local runtime first. A cloud model remains available as a
comparison condition and fallback, but the fallback must be visible: the run
record must say why it was used and what prompt content was sent.

That rule is more important than a clever router. A router can optimize for a
metric while concealing the data-transfer decision. For the first evaluation,
the routing policy will be simple and inspectable:

| Condition | Route |
| --- | --- |
| Task contains credentials, personal data, client data, or private infrastructure details | Do not run it in the corpus. |
| Local model completes the task within the defined limit | Keep the local result. |
| Local model times out, fails a tool call, or produces an unacceptable reviewed result | Record the failure, then use the declared cloud comparison condition if the task is eligible. |
| Any action could alter infrastructure | Stop for a human review of the diff and Terraform plan. |

This is a hybrid experiment, not a privacy promise. Local inference may avoid
sending a prompt to a model API, but editor telemetry, model downloads, source
control, tools, logs, and a cloud fallback can all create other data paths.

## Why a 48 GB Apple Silicon profile

Kevin Lewis's account of a 48 GB M4 Pro Mac mini provides a useful comparison
profile, not a performance guarantee. He reports using a quantized
Qwen3.6-35B-A3B model alongside a smaller Gemma model, and explains why model
weights, operating-system headroom, and the context cache compete for unified
memory. His reported speeds and memory figures belong to his machine and
workload; they will not be reused as results here.

The baseline therefore targets a machine with 48 GB of unified memory and
records the actual processor, memory, operating system, memory headroom,
runtime release, model artifact, quantization, and agent version before every
run. A smaller machine is not excluded, but it is a different test condition.

The next article will pin the exact runtime and model artifacts. Naming a model
family is not enough: the publisher, revision, quantization, licence, and
checksum determine what was actually tested.

## What the experiment will and will not do

The Terraform target will be a self-contained fixture with no credentials,
remote state, or reachable production provider. It should support formatting,
validation, and a predictable plan without creating an operational path to
real infrastructure.

No generated Terraform change will be applied automatically. A person must
read both the source diff and the plan before any command capable of changing
infrastructure. That boundary applies even when a model appears to have
completed a task correctly.

The repository also excludes model weights, runtime caches, raw logs,
credentials, Terraform state, and private prompts. Only reviewed prompt
templates and aggregate measurements will be published.

## How the comparison will work

The evaluation uses small, self-contained Terraform and platform tasks from a
published corpus. Each model-and-routing condition runs every task at least
three times from a clean checkout. The record for each attempt will include:

- task completion and reviewer acceptance;
- `terraform fmt -check`, `terraform validate`, and plan quality;
- elapsed time and generated-token rate when the runtime exposes it;
- peak memory and CPU or GPU use when the platform reports it;
- applicable API cost and stated electricity assumptions;
- timeouts, tool errors, failure modes, and human intervention; and
- the hardware, operating system, runtime, model, harness, task, prompt, and
  repository revisions.

This makes an inconvenient result publishable. A failed tool call, a slow
model, or a rejected plan is part of the answer. The later evaluation article
will separate measurements from recommendations: one machine and model
revision cannot establish a general rule.

## Alternatives rejected for the first run

A cloud-only workflow remains useful as a comparison, but cannot answer
whether a local workflow is viable. A local-only workflow hides the trade-off
when a task needs a stronger model. Automatic quality-based routing is also
deferred: its policy and data flow would need evaluation of their own.

The broader tooling landscape is active. The [Awesome AI Model Routing
catalogue](https://github.com/Not-Diamond/awesome-ai-model-routing) lists
several routing approaches, while [Awesome Local
LLM](https://github.com/rafska/awesome-local-llm) and [Awesome
Agents](https://github.com/kyrolabs/awesome-agents) map local runtimes and
agent integrations. These are discovery catalogues, not evidence that a tool
is suitable for this workload. [Awesome
IaC](https://github.com/brandonhimpfen/awesome-iac) similarly identifies
Terraform testing and validation tools, but the safe fixture must demonstrate
its own behaviour.

## What comes next

The four posts are scheduled for consecutive Sundays:

1. 4 October: this research and design decision.
2. 11 October: the reproducible baseline environment.
3. 18 October: reusable Terraform tasks and the routing policy.
4. 25 October: the measured evaluation and its failure cases.

The full research record, including risks, source-attribution requirements,
and evaluation protocol, is available in the [companion repository at this
revision](https://github.com/abuxton/local-llm-tooling-series/blob/e6853f034ee49a9bfdef94c2fd28b0f7b7713878/docs/research-design.md).
The follow-up work is tracked in
[#70](https://github.com/abuxton/abuxton.github.io/issues/70),
[#71](https://github.com/abuxton/abuxton.github.io/issues/71), and
[#72](https://github.com/abuxton/abuxton.github.io/issues/72).

## Sources

- Kevin Lewis, "[My local model setup on an M4 Pro Mac mini](https://lws.io/blog/my-local-model-setup/)," 1 September 2026, accessed 9 September 2026.
- [Awesome AI Model Routing](https://github.com/Not-Diamond/awesome-ai-model-routing), accessed 9 September 2026.
- [Awesome Local LLM](https://github.com/rafska/awesome-local-llm), accessed 9 September 2026.
- [Awesome Agents](https://github.com/kyrolabs/awesome-agents), accessed 9 September 2026.
- [Awesome IaC](https://github.com/brandonhimpfen/awesome-iac), accessed 9 September 2026.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
