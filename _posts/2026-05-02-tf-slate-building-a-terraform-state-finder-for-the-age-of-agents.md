---
layout: post
title: "tf-slate: Building a Terraform State Finder for the Age of Agents"
date: 2026-05-02 20:00:00 +0000
categories: [development, terraform, ai, tools]
tags: [terraform, go, state-management, ai-agents, infrastructure-as-code, cli, tui, open-source, state-sprawl]
---

There is a repository I built called [tf-slate](https://github.com/abuxton/tf-slate). It is a Go CLI that walks a filesystem looking for Terraform state files, summarises what it finds, and drops you into an interactive terminal where you can inspect, list, or destroy resources — or just open a shell in the directory and get on with your day.

The name is two things at once. `tf` as in [Terraform state](https://developer.hashicorp.com/terraform/cli/commands/state). `slate` as in a [clean slate](https://dictionary.cambridge.org/dictionary/english/clean-slate). Getting a clear picture of what exists, before you do anything else.

This post is an attempt to write honestly about why I built it, what the development actually looked like, what I think works and what doesn't, and where it probably needs to go next.

## The Problem: State Sprawl

If you have worked with Terraform at scale — across multiple providers, multiple teams, multiple environments — you already know what state sprawl looks like. State files in different directories, some managed by remote backends, many more that aren't, accumulated across months or years of experimentation and migration and "I'll tidy this up later."

The official tools help when you know what you're looking for. `terraform state list` is useful when you're already inside a specific Terraform root. The problem is when you don't know what exists, or where, or whether something was actually applied or just planned and abandoned. That question — "what's actually out there?" — isn't well served by anything in the standard Terraform toolchain.

I have felt this friction for a long time. The immediate trigger for building something was actually a different problem.

## AI Agents Lose Context

I've been running coding agents with increasing regularity — GitHub Copilot agent sessions, Claude, experimenting with multi-agent setups. And one thing I noticed was this: when you are running several agents across a sprawling filesystem, possibly working across different directories, doing different tasks, they lose track of what has already been built or tested with Terraform.

An agent working on an infrastructure task in `services/database/` doesn't automatically know about the state file sitting in `infra/legacy/` from six months ago that still contains live resources. A human engineer who had been around long enough would probably know. An agent, starting fresh, doesn't. It can't find what it doesn't know to look for.

The idea behind tf-slate is that you give an agent a tool that can answer the question: *what Terraform state exists on this filesystem, right now, and what does it contain?* With the right output format — JSON, YAML, structured text — that becomes something you can pipe into an agent's context directly. The agent can orient itself. It can see what has been built, which providers are in play, which state files are empty and which aren't.

That's the context: tf-slate is partly a developer convenience tool, and partly infrastructure for giving agents a more accurate picture of the world.

## What It Actually Does

The core is straightforward. `tf-slate` walks a directory tree recursively, finds every file ending in `.tfstate`, reads each one, and produces a summary:

- the file path
- the number of managed resources
- the provider or providers in use
- the Terraform version and serial metadata

```bash
tf-slate .
```

That's the minimal invocation. Everything else is layered on top.

You can filter to show only state files with actual resources in them (`-non-zero`, `-nz`), sort by the heaviest state files first (`-weighted`, `-w`), or print a summary table grouping them by zero vs non-zero resource counts (`-summarize`, `-s`).

In non-interactive mode (`--ni`, `--non-interactive`) you can emit JSON, YAML, or CSV — which is where the agent use case comes in. Pipe that into an agent's context and it has a structured map of what Terraform has actually built.

The interactive mode is the more interesting half. After displaying the state file list, tf-slate prompts you to select one and then offers a short menu of follow-up operations:

- `list` — runs `terraform state list` on the selected state file and lets you navigate into individual resources
- `show` — runs `terraform state show` for a specific resource address
- `destroy` — runs `terraform destroy` with an explicit `DESTROY` confirmation gate
- `visit` — opens a shell in the directory containing the state file and exits tf-slate

That last one is the one I use most. When you've found what you were looking for, `visit` drops you exactly where you need to be.

## The Development: Honest About What Happened

tf-slate was [built with agent assistance](https://github.com/abuxton/tf-slate/commits/main), and I want to be honest about what that actually meant.

The initial shape of the project came together quickly. The core scanning logic, the state file parsing, the flag definitions — the kind of scaffolding work that would have taken me a solid day to set up carefully in Go, and which an agent can structure in a session. That was legitimately useful. The implementation of `FindStateFiles`, `SummarizeStateFile`, the struct definitions for the state JSON format — all solid, all testable, and produced without me having to wrangle the Go tooling from scratch.

What took longer was the interactive TUI. The first version of the interactive prompt was functional but a bit rough at the edges — the kind of thing that works until a user does something unexpected, and then doesn't. The nested list navigation (where you can pick a resource from the `terraform state list` output and then inspect it directly, or go `back` to the file list) went through a few iterations. Getting the flag aliases consistent — `-nz`, `-w`, `-s`, `-o`, `-ni` alongside the full `--non-zero`, `--weighted`, etc. — required an explicit cleanup pass.

The test coverage is good. The tests are real, they test meaningful behaviour, and they were written alongside the implementation rather than as an afterthought. That discipline came partly from the development environment having Go test conventions baked in, and partly from the fact that the parsing logic is where the subtle bugs live — in state file formats, in how providers are named across different Terraform versions, in edge cases around resources with zero instances.

The Taskfile was a deliberate addition. I work with [go-task](https://taskfile.dev) extensively now, and having a `Taskfile.yml` that wraps `build`, `validate`, `dev`, and `release:prepare` makes the project usable without needing to remember the exact `go run` incantations. It also made the CI and release workflow easier to reason about, because the Taskfile and the GitHub Actions workflow share the same verbs.

The release workflow took longer than it should have. The `task release:prepare` flow — which creates a release branch, updates `CHANGELOG.md`, and opens a pull request — went through several iterations around the `awk` insertion logic for the changelog. That's the kind of problem that is simple in principle and irritating in practice: cross-platform shell differences, macOS vs Linux `sed` and `awk` behaviour, making dry run mode actually safe. There's a commit in the history called *"fix: support release changelog insertion on macOS"* which tells its own story.

## What I Think Works

The output format options are the part I'm most pleased with. Making `--ni --output json` genuinely useful as a machine-readable interface — not an afterthought, not just dumping structs, but a consistent structured format that includes all the fields an agent or downstream tool would need — was worth the effort.

The `visit` command is genuinely useful in a way I didn't fully anticipate. The TUI does a good job of helping you find the right state file, and then the natural follow-up is: I want to be in that directory. Having a single-word action that drops you there and exits cleanly is the kind of ergonomic win that small tools often miss.

The internal package structure — `internal/state` for the parsing and discovery logic, `internal/output` for the format handling, `cmd/tf-slate` for the CLI and TUI — means the testable logic is separated from the interactive layer. That boundary is worth maintaining.

## What I'm Less Sure About

The interactive TUI is built on `bufio.Reader` and `fmt.Fprintf`. That works, but it is not a TUI framework. If the tool grows — more operations, more navigation levels, state that needs to persist across selections — a framework like [bubbletea](https://github.com/charmbracelet/bubbletea) would give the interactivity more room to breathe. Right now the UX is functional. It is not beautiful.

The `destroy` operation sitting behind a typed confirmation is the right call for safety, but I'm not entirely comfortable with `terraform destroy` being in the menu at all. It is there because the tool is about state operations, and destroy is a natural state operation. But I think it probably belongs behind a flag — `--allow-destructive` or similar — rather than being available by default in every interactive session. Someone tired, working quickly, could have a bad day.

There is no remote state support. The tool only finds local `.tfstate` files. If your state lives in an S3 backend, or Terraform Cloud, or any other remote backend, tf-slate doesn't see it. That's a significant gap if you're working in a team environment where remote backends are the norm. A future version that could also query configured remote backends — reading backend configuration from `*.tf` files in the discovered directories — would be substantially more useful.

## Where It Probably Goes Next

If I'm being honest about the roadmap, there are three things that would make tf-slate significantly more useful:

**Remote backend discovery.** Parse `backend` blocks from `*.tf` files alongside `.tfstate` files, and where credentials are available, query the configured remote backends for state summaries. This is not a small addition — remote backends all have different APIs, and the credential handling alone is a project — but it's the thing that would make the tool genuinely useful in team environments rather than just personal/experimental setups.

**An MCP server interface.** I've already added a `mcp.json` to the repository as a placeholder. An [MCP server](https://modelcontextprotocol.io) wrapping the core state discovery logic would let coding agents call tf-slate directly rather than relying on subprocess execution or context injection. The agent asks: "what Terraform state exists under `/workspace`?" and tf-slate answers via tool call. That's a cleaner integration than piping JSON into a context window.

**State drift detection.** Compare the current state file contents against the last known state — serial number, lineage, resource count changes — and flag anything that has changed unexpectedly. This would turn tf-slate from a discovery tool into a lightweight monitoring tool, which is a different use case but a natural extension of the same core capability.

## On Building with Agents

There's a version of this post I could write that is pure enthusiasm about agentic development — about how fast the scaffolding went up, about test coverage appearing before I had to ask for it. That version would be incomplete.

The honest version is that building tf-slate with agent assistance was fast and occasionally frustrating in equal measure. The agent was good at Go idioms, solid on test structure, excellent at flag handling. It was less reliable on the interaction between the TUI logic and the test layer, which required more direct intervention. And there were moments — particularly around the release tooling — where the agent confidently produced something that didn't work on macOS, required debugging, and cost more time than writing it myself from the start would have.

This is the current state of AI-assisted development. Not "the agent does the work." More like: the agent handles the parts it's good at, you handle the parts it isn't, and the hard part is knowing which is which before you've already lost an hour. I've been [writing about this](https://blog.abcdevelopment.co.uk/ai/engineering-culture/2026/04/27/ai-burnout-and-the-loss-of-an-ideal.html) in other contexts, and tf-slate is a concrete example of the dynamic in practice.

What I will say is that the end result is a tool I would use and would recommend. The code is readable. The tests are real. The scope is honest about what it does and doesn't do. That feels like the right outcome for an early-stage tool that is genuinely trying to solve a real problem.

The [repository is public](https://github.com/abuxton/tf-slate). Brew tap is available (`brew tap abuxton/tap && brew install abuxton/tap/tf-slate`). Pull requests welcome.

Start with `tf-slate .` from a directory you know has some `.tfstate` files in it. See what you've got.
