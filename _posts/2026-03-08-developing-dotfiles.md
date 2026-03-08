---
layout: post
title: "The Development of github.com/abuxton/dotfiles"
date: 2026-03-08 17:00:00 +0000
categories: [development, github, ai]
tags: [dotfiles, copilot, agents, openspec, shell, devtools]
---

Every developer has that repository they keep coming back to — the one they tweak quietly over years until it starts to look like the inside of their brain. For me, that repository is [abuxton/dotfiles](https://github.com/abuxton/dotfiles). This post is a look back at how it evolved from a well-known community fork into something shaped much more deliberately by AI-assisted development.

## Where It Came From: Standing on the Shoulders of Mathias

The `abuxton/dotfiles` repository has a lineage that stretches back over a decade. It was forked from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles), one of the most celebrated dotfiles projects in the GitHub community. Mathias Bynens' dotfiles have been a reference point for macOS/BSD developers since at least 2012, touching on everything from `.osx` macOS preferences scripts to a thoughtful `.gitconfig` with useful shorthand aliases. Thousands of developers have forked it as a sensible starting point, and the commit history reflects that collaborative lineage — early commits in the repo bear names like Mathias himself, Sindre Sorhus, and a long list of community contributors.

My fork started with those solid foundations in place.

## Five Years of Quiet Iteration

For the first several years after I forked the project, development followed a pattern familiar to anyone with a dotfiles repo: incremental, personal, mostly undocumented. Looking at the commit history, you can trace the tools I was using professionally at any given time:

- **2020**: HashiCorp tools start appearing — Vault, Consul, Terraform helpers, and Vagrant support. Go and Python profiles get added. Docker-specific configuration lands. Powerlevel10k takes over the ZSH prompt.
- **2021–2024**: Incremental updates — Kubernetes helpers, `fzf` integrations, cloud provider profiles for AWS, Azure, and GCP, pipx support, and general quality-of-life improvements.
- **Early 2025**: Tidying up — removing unused items like `thefuck` and refining paths and completions.

This was dotfiles as personal archaeology: each file a fossil of a project or tool that mattered at the time. The repo worked, but it was sprawling and undocumented, bootstrapped by a single `bootstrap.sh` that had grown organically and was decidedly not safe to run twice.

## The February 2026 Transformation

Then, over roughly two weeks in February and early March 2026, the repository went through a substantial transformation — one that was meaningfully shaped by GitHub Copilot's coding agent.

The spark was a desire to take the repo more seriously: make the setup reproducible, add CI validation, and — crucially — integrate proper support for AI agent tooling that had become central to my daily workflow. What started as a cleanup became a structural rethink.

### The Initial Refactor (PR #1 and #2)

The first pull request — [feat(scripts) update and major refactor and add Agentic support](https://github.com/abuxton/dotfiles/pull/1) — set the direction. The messy `bootstrap.sh` was split into a proper three-script setup:

1. **`bootstrap.sh`** — run once per machine; handles `git pull`, Oh My Zsh installation, and bulk `rsync` deployment of dotfiles.
2. **`setup.sh`** — idempotent; creates symlinks, configures profiles, sets up the environment safely on every run.
3. **`deploy-agents.sh`** — new; deploys AI agent configurations to the home directory.

PR #2 was, fittingly, generated directly by the Copilot coding agent to fix the very CI workflow it had helped create — the `validate-dotfiles.yml` GitHub Actions workflow needed adjustments to properly run `bootstrap.sh` in the home directory context it expects. Using the agent to fix its own output in the same sitting felt like a preview of a new kind of development loop.

### CI/CD and Validation

A `validate-dotfiles.sh` script and a corresponding GitHub Actions workflow brought real automated validation to the repository for the first time. The workflow checks shell syntax, POSIX compliance, script permissions, symlink targets, and runs the setup scripts in a dry-run mode. It runs on every push and pull request, catching regressions before they reach `main`.

This is the sort of infrastructure I'd have put off indefinitely when working alone — setting up CI for personal dotfiles feels like over-engineering until the moment it catches something. The agent made it faster to do properly than to skip.

### Agent Configuration as a First-Class Concern

The new `deploy-agents.sh` script is perhaps the most distinctive addition. It symlinks a structured `agents/` directory in the repository into the appropriate locations in `$HOME`:

```
~/.agents/     ← skills, prompts, commands for all agents
~/.bob/        ← Bob agent configuration
~/.claude/     ← Claude configuration
~/.github/     ← GitHub Copilot configuration
~/.opencode/   ← OpenCode CLI configuration
~/AGENTS.md    ← primary workflow documentation
```

The idea is that agent configuration becomes as portable and reproducible as the rest of the development environment. Running `deploy-agents.sh` on a new machine gives every AI tool I use the same context and skills from the start.

## The OpenSpec Workflow and Agent Skills

Perhaps the biggest shift in approach was adopting **OpenSpec** as the primary workflow for managing changes to the repository itself. OpenSpec is an artifact-driven development system that structures changes through a series of documents before touching code:

1. **Proposal** — what and why
2. **Specs** — technical requirements and acceptance criteria
3. **Design** — architecture and approach
4. **Tasks** — concrete implementation steps

These artifacts live in `openspec/changes/<change-name>/` and serve both as planning documents and as persistent context for the agent working on the implementation.

The skills that support this workflow are defined in `.github/skills/` (for GitHub Copilot), `.opencode/skills/` (for OpenCode CLI), and the unified `agents/.agents/skills/` directory deployed by `deploy-agents.sh`. Each skill is a structured prompt that tells the agent how to behave in a given mode — `openspec-new-change`, `openspec-apply-change`, `openspec-verify-change`, and so on. The skills are consistent across agents, which means the same structured approach works whether you are using Copilot in VS Code, Claude in a terminal, or OpenCode as a CLI tool.

The change that migrated and extended all the HashiCorp and Rancher-specific profiles (PRs #10–#13) was structured using this approach — with the agent working through tasks methodically rather than making ad-hoc edits.

## What Changed About the Approach

Looking back at the `git log`, the pattern before February 2026 is: small commits, single-line messages, no structure. The pattern after is: pull requests with descriptions, conventional commit messages (`fix(setup.sh): use correct path in .ssh symlink elif branch`), CI that must pass, and an artifact trail for significant changes.

The presence of an AI coding agent didn't just accelerate implementation — it changed the incentives around structure. When working with an agent, a clear spec is not a luxury; it is how you get the outcome you want. Writing a proposal before asking the agent to implement anything pays off immediately in the quality of what you get back.

The skills framework also provided something I had not expected to find useful: it made the agent's behaviour consistent and predictable. Rather than writing a fresh instruction every time, invoking a skill like `openspec-apply-change` means the agent knows exactly what mode it is in and what its responsibilities are. That consistency compounds over time.

## Looking Forward

The repository is now a more accurate reflection of how I actually work: with multiple AI tools, a structured change process, and an environment that travels well from machine to machine. The dotfiles repo started as infrastructure and has become, to a degree, a statement of method.

The Mathias Bynens fork gave me a strong foundation and years of good defaults. What the past few weeks demonstrated is that the next stage of that evolution is collaborative — not just between developers and their past selves, but between developers and the agents they work alongside.

The repository is at [github.com/abuxton/dotfiles](https://github.com/abuxton/dotfiles) if you want to have a look. As always: fork it, review it, and remove anything that doesn't apply to you.
