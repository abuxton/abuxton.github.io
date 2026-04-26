---
layout: post
title: "Getting Started with Terraform: From Root Module to Reusable Components"
date: 2026-04-30 09:00:00 +0000
categories: [infrastructure, terraform]
tags: [terraform, hcl, infrastructure-as-code, modules, devops, hashicorp, iac]
---

Infrastructure as code has fundamentally changed how we build and manage systems. Terraform, HashiCorp's declarative infrastructure tool, is one of the most widely adopted tools in that space. It is also one of the most frequently misunderstood — particularly when it comes to how code should be structured as a project matures from a personal experiment to a shared, collaboratively maintained platform.

This post walks through that journey. It uses the [terraform-hcl-enablement](https://github.com/abuxton/terraform-hcl-enablement) repository as a practical reference — a staged learning path that takes you from a bare root module declaration to a governable, testable, reusable component architecture. It also references the [Terraform HCL Enablement YouTube series](https://www.youtube.com/watch?v=HODjaSPQdPQ&list=PL81sUbsFNc5Z93-eRproLp88vI_IxbDBY) as companion viewing.

Before diving into the stages, it is worth establishing the vocabulary that will be used throughout.

## Defining Module Types

Terraform uses the word "module" frequently, and the informal usage is sometimes imprecise. For the purposes of this post — and the enablement repository — three terms are used with specific, intentional meanings.

**Root Module**

A root module is a top-level Terraform declaration of code representing infrastructure. It is the entry point: the directory you run `terraform init`, `terraform plan`, and `terraform apply` from. Every Terraform project has at least one root module. It owns the provider configuration, the backend, and the state. It may be a small personal project or a sprawling monorepo workspace managing dozens of services — but in both cases, it is the root.

**Child Module**

A child module is a local module developed within the same repository as the root, designed for reuse of component resources across a larger codebase. It lives in a subdirectory (commonly `modules/`) relative to the root and is called with a `source = "./modules/name"` reference. A child module has no provider configuration of its own — it inherits that context from the root. Its value is encapsulation: you extract a pattern of resources into a named abstraction, and the root calls it as many times as it needs. In a monorepo with multiple root modules, a shared child module can be referenced by each of them.

**Component Module**

A component module is a remotely sourced module — either from the Terraform Registry, a Git repository, an S3 bucket, or another supported source — that can be independently versioned, managed, and developed. It is typically maintained by a separate team or consumed from a community registry. The root module references it with a versioned source string, such as `source = "registry.terraform.io/namespace/module/provider"` or `source = "git::https://github.com/org/module.git?ref=v1.2.0"`. Component modules enable sharing across organisations and enable the kind of governance that comes with independent version management: teams can pin to a tested version and upgrade deliberately.

These definitions are not official HashiCorp terminology — they are useful conceptual categories that emerge from practice. The enablement repository illustrates each one in turn.

## The Enablement Repository

The [terraform-hcl-enablement](https://github.com/abuxton/terraform-hcl-enablement) repository contains five staged examples, each building on the last. Intentionally, the examples use only HashiCorp's utility providers — `hashicorp/random` and `hashicorp/time` — so there is no cloud account required. You can run every stage with a local `terraform init` and `terraform apply`.

The stages are:

| Stage | Directory | Concept |
|---|---|---|
| 1 | `stage-1-root-module` | Bare root module with resources and outputs |
| 2 | `stage-2-root-with-locals` | Root module with `locals` for configuration |
| 3 | `stage-3-child-module` | Root delegates to a local child module |
| 4 | `stage-4-component-source` | Component source layout with Terraform tests |
| 5 | `stage-5-governable-defaults` | Variables with `locals`-driven governable defaults |

### Stage 1: The Root Module

Stage 1 is the simplest possible starting point. Two resources, no variables, no modules.

```hcl
resource "random_pet" "label" {
  length    = 2
  separator = "-"
}

resource "time_static" "created" {}
```

This is what most Terraform journeys look like on day one. You have an idea, you need some infrastructure, and you write the resources directly. The `versions.tf` file constrains the provider versions, which is good practice from the outset:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}
```

This stage represents the beginning of a personal infrastructure project — the kind of code you might write to experiment, to automate something for yourself, or to prototype a concept. It is the seed from which everything else grows.

### Stage 2: Root with Locals

Stage 2 introduces `locals` — a way of declaring named values within the root module without exposing them as external inputs.

```hcl
locals {
  name_prefix = "stage2"
  pet_length  = 2
  separator   = "-"
  ttl_hours   = 6
}

resource "random_pet" "label" {
  prefix    = local.name_prefix
  length    = local.pet_length
  separator = local.separator
}

resource "time_static" "created" {}

resource "time_offset" "expires" {
  base_rfc3339 = time_static.created.rfc3339
  offset_hours = local.ttl_hours
}
```

This is a small but significant improvement. Rather than hardcoding values directly in resource blocks — which becomes unmaintainable as a project grows — `locals` creates a single place to define configuration. Changing `ttl_hours` now means changing it in one place, not hunting through resource blocks.

In a monorepo context, `locals` also plays a governance role: they allow a team to set defaults that are applied consistently across all resources in a root module, without requiring every caller to supply explicit values.

### Stage 3: Root with Child Module

Stage 3 is where modularisation begins. The resources from stage 2 are extracted into a child module at `modules/nested_label`, and the root delegates to it.

The child module (`modules/nested_label/main.tf`):

```hcl
resource "random_pet" "label" {
  prefix    = var.name_prefix
  length    = var.pet_length
  separator = var.separator
}

resource "time_static" "created" {}

resource "time_offset" "expires" {
  base_rfc3339 = time_static.created.rfc3339
  offset_hours = var.ttl_hours
}
```

The root module (`main.tf`):

```hcl
locals {
  name_prefix = "stage3"
  pet_length  = 2
  separator   = "-"
  ttl_hours   = 12
}

module "nested_label" {
  source = "./modules/nested_label"

  name_prefix = local.name_prefix
  pet_length  = local.pet_length
  separator   = local.separator
  ttl_hours   = local.ttl_hours
}
```

The child module has its own `variables.tf` and `outputs.tf`, giving it a clean contract: you pass values in, you get outputs back, and the implementation is encapsulated. This is the pattern for building reusable abstractions within a monorepo.

If you imagine a monorepo with five or ten root modules — each representing a different environment or service — a shared child module means you write the resource logic once and call it everywhere. When you need to change how the label is generated, you change it once.

### Stage 4: Component Source Layout

Stage 4 introduces the component source pattern and, significantly, Terraform tests.

The layout shifts from `modules/` to `components/`, signalling a conceptual distinction: the `utility_component` here is structured as if it were a separately sourceable module. The comment in the main file makes this explicit:

```hcl
# equivalent to an example of sourcing registry.terraform.io/abuxton/utility_component/local
module "utility_component" {
  source = "./components/utility_component"

  name_prefix = local.name_prefix
  pet_length  = local.pet_length
  separator   = local.separator
  ttl_hours   = local.ttl_hours
}
```

The `./components/utility_component` path stands in for what would, in a real-world scenario, be a registry source or a Git URL. This is the staging ground before extraction: the component is developed locally, given its own interface, and tested — then ready to be published when the time comes.

The `tests/` directory introduces `terraform test`, which was added to Terraform in version 1.6. Tests can validate that module behaviour matches expectations, providing confidence before applying to real infrastructure.

### Stage 5: Governable Defaults

Stage 5 adds variables to the root module alongside the existing `locals` pattern, using `coalesce` to merge caller-supplied values with opinionated defaults:

```hcl
locals {
  defaults = {
    name_prefix = "stage5"
    pet_length  = 2
    separator   = "-"
    ttl_hours   = 24
  }

  effective = {
    name_prefix = coalesce(var.name_prefix, local.defaults.name_prefix)
    pet_length  = coalesce(var.pet_length, local.defaults.pet_length)
    separator   = coalesce(var.separator, local.defaults.separator)
    ttl_hours   = coalesce(var.ttl_hours, local.defaults.ttl_hours)
  }
}

module "utility_component" {
  source = "./components/utility_component"

  name_prefix = local.effective.name_prefix
  pet_length  = local.effective.pet_length
  separator   = local.effective.separator
  ttl_hours   = local.effective.ttl_hours
}
```

This is the governance pattern. A root module declares what the defaults are — encoding the policy of the platform team or the organisation — while still allowing callers to override specific values when they have a legitimate reason to do so. `coalesce` uses the first non-null value, so if `var.name_prefix` is `null` (i.e., the caller did not supply it), the default is used.

This pattern scales well. A platform team can publish a root module with sensible defaults baked in, and development teams can consume it with overrides only where they genuinely differ. The defaults are visible, version-controlled, and testable.

## The Arc of the Journey

Stepping back, the five stages map cleanly onto how infrastructure codebases naturally evolve:

1. **Personal project** — You write what you need, hardcoded, fast. Stage 1 and early stage 2.
2. **Organised project** — You introduce `locals` to centralise configuration. You start thinking about maintainability. Late stage 2.
3. **Monorepo** — As the codebase grows, you extract repeated patterns into local child modules. Stage 3.
4. **Collaborative platform** — You develop components as first-class modules with their own interfaces and tests, ready to be independently versioned and shared. Stages 4 and 5.
5. **Component registry** — The component is published to the Terraform Registry (or an internal registry), given semantic versioning, and consumed across teams and organisations. This is the implicit next step beyond stage 5.

The repository never reaches the registry step explicitly — it uses local paths throughout — but stage 4's comment makes the mapping clear. The `./components/utility_component` local source is the local equivalent of `registry.terraform.io/abuxton/utility_component/local`.

## Trying It Yourself

Each stage is self-contained and runnable. Clone the repository and work through the stages in order:

```bash
git clone https://github.com/abuxton/terraform-hcl-enablement
cd terraform-hcl-enablement

# Work through each stage
cd examples/stage-1-root-module
terraform init -backend=false
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

For stages 4 and 5, you can also run the test suite:

```bash
cd examples/stage-4-component-source
terraform init -backend=false
terraform test
```

No cloud credentials are required. The `hashicorp/random` and `hashicorp/time` providers work entirely locally.

## The YouTube Series

The [Terraform HCL Enablement YouTube series](https://www.youtube.com/watch?v=HODjaSPQdPQ&list=PL81sUbsFNc5Z93-eRproLp88vI_IxbDBY) is a companion video series that walks through the same concepts covered by the enablement repository. It is intended for engineers who are either new to Terraform or looking to bring more structure and rigour to codebases that have grown organically.

The series covers the full development journey — from writing your first resource block to structuring modules for reuse and publishing component modules that other teams can consume. It addresses the questions that come up repeatedly in practice: when should you extract a module, how do you decide what belongs in `locals` versus `variables`, how do you test Terraform code, and how do you design modules so they can be governed without being inflexible.

The playlist is structured so that each video builds on the previous one, mirroring the staged approach of the repository. Watching the series alongside working through the code stages is a practical way to build both the conceptual understanding and the hands-on skills.

## Further Reading

- [terraform-hcl-enablement repository](https://github.com/abuxton/terraform-hcl-enablement) — The staged code examples referenced throughout this post
- [Terraform HCL Enablement YouTube Series](https://www.youtube.com/watch?v=HODjaSPQdPQ&list=PL81sUbsFNc5Z93-eRproLp88vI_IxbDBY) — Companion video series
- [Terraform Module Documentation](https://developer.hashicorp.com/terraform/language/modules) — HashiCorp's official module documentation
- [Terraform Registry](https://registry.terraform.io) — Public registry for community and verified modules
- [terraform test Documentation](https://developer.hashicorp.com/terraform/language/tests) — Official documentation for the `terraform test` command
- [hashicorp/random Provider](https://registry.terraform.io/providers/hashicorp/random/latest) — The utility provider used across all stages
- [hashicorp/time Provider](https://registry.terraform.io/providers/hashicorp/time/latest) — The time provider used across all stages
