---
layout: post
title: "A Reproducible Local LLM Baseline for Terraform"
date: 2026-10-11 09:00:00 +0000
categories: [ai, development]
tags: [local-llm, terraform, reproducibility, ai-agents, platform-engineering]
---

What does a reproducible local LLM environment for Terraform work look like
when it is designed not to become an accidental deployment system?

For this series, it is a version-pinned local runtime, a locally addressed
agent client, and a Terraform fixture that can validate and produce a plan
without a provider, remote backend, credentials, or an apply target. This is
the baseline for later experiments; it is not evidence that the selected model
is fast, capable, private, or cheaper than a cloud model.

The complete configuration is in the [companion repository at immutable
revision `fc89ea8`](https://github.com/abuxton/local-llm-tooling-series/tree/fc89ea8d15de1bd67ebca88d61891cd790714c5b).
It records both the commands and the checks needed to repeat the environment.

## The baseline is a set of identities, not model names

“Ollama and a coding model” is not sufficient to reproduce an experiment.
Both can change without the command line changing. The baseline instead
records an artifact or manifest identity for every component:

| Component | Baseline pin |
| --- | --- |
| Runtime | Ollama v0.40.1, including the published macOS ARM archive SHA-256 |
| Model | `qwen2.5-coder:7b`, resolved to its Ollama registry manifest digest |
| Agent client | `aider-chat==0.86.1` installed from a one-line requirements file |
| Terraform | v1.13.5, with an exact configuration constraint |

The runtime archive checksum verifies the download before it is installed. The
model tag is resolved to a manifest digest, and the run record captures
`ollama show ... --verbose`. That distinction matters: a tag identifies a
convenient request, while a digest identifies the artifact used in the
experiment.

The repository does not distribute model weights. Before downloading one,
review its publisher terms, licence, and intended-use restrictions. A model
that technically fits a machine may still be unsuitable for the intended
work.

## Local first is not a secret-handling strategy

The agent wrapper fixes the OpenAI-compatible endpoint to
`http://127.0.0.1:11434/v1`, disables automatic commits, and prevents local
chat-history files. It does not configure a cloud endpoint or fallback.

Those choices reduce accidental data movement in this particular baseline.
They do not make the workflow private by declaration. Model downloads, source
control, editor extensions, operating-system telemetry, tool calls, and
manually enabled fallbacks are separate data paths. Credentials, client data,
personal data, private infrastructure details, raw prompts, responses, and
logs are excluded from this experiment rather than passed to a supposedly
safe local endpoint.

The companion `.gitignore` excludes common local configuration, model data,
logs, Python environments, Terraform state, plan files, and tooling. That is
a guardrail, not a secret scanner. Before each commit, inspect the staged
files and the ignored output. The publishable record contains redacted
metadata and aggregate results, not transcripts by default.

## The Terraform fixture proves a narrow property

The safe test target has one `terraform_data` resource. That resource belongs
to Terraform itself, so the fixture has no external provider configuration,
backend, modules, credentials, or reachable infrastructure target.

```sh
make sandbox-validate
make sandbox-plan
```

The plan command initializes with `-backend=false`, disables refresh, creates
only an ignored local plan file, prints it, and stops. There is intentionally
no `apply`, `destroy`, or deployment target in the Makefile.

I ran the fixture with the pinned Terraform 1.13.5 binary: formatting and
validation passed, and the plan reported one `terraform_data.baseline` object
to create with zero changes and zero destroys. That only demonstrates that the
fixture is isolated and executable. It does not demonstrate that an
LLM-generated change is valid, much less safe to apply.

> **Human-review boundary:** A person must review both the generated source
> diff and the printed Terraform plan before any command that could change
> infrastructure. A safe fixture is not permission to repoint it at a real
> provider or backend.

## What this baseline deliberately leaves unanswered

No benchmark result appears in this article. The baseline needs a public task
corpus, fixed prompt templates, clean checkouts, repeated runs, and a record
of failure before it can support a performance or quality conclusion.

The next milestone, [#71](https://github.com/abuxton/abuxton.github.io/issues/71),
will introduce those Terraform and platform-engineering tasks together with an
explicit routing policy. The final evaluation in
[#72](https://github.com/abuxton/abuxton.github.io/issues/72) will report
completion, Terraform validation and plan quality, latency, resource use,
applicable cost, and failures. It must distinguish an observation on this
machine and revision from a general recommendation.

This baseline fulfils [#70](https://github.com/abuxton/abuxton.github.io/issues/70):
the configuration is public, pinned, intentionally non-production, and
reviewable without containing credentials or private infrastructure detail.

## Sources

- [Ollama v0.40.1 release](https://github.com/ollama/ollama/releases/tag/v0.40.1),
  accessed 8 October 2026. The release publishes the runtime archive and
  SHA-256 digest used by this baseline.
- [Ollama model library: Qwen2.5-Coder](https://ollama.com/library/qwen2.5-coder),
  accessed 8 October 2026. The registry manifest digest in the companion
  repository identifies the model artifact selected for this configuration.
- [Aider installation documentation](https://aider.chat/docs/install.html),
  accessed 8 October 2026. It documents the isolated Python installation used
  for the pinned agent client.
- [Terraform v1.13.5 release](https://github.com/hashicorp/terraform/releases/tag/v1.13.5),
  accessed 8 October 2026. It supplies the exact CLI version used to validate
  and plan the isolated fixture.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
