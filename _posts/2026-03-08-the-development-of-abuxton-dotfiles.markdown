---
layout: post
title: "The Development of abuxton/dotfiles: From Shell Config to AI-Powered Environment"
date: 2026-03-08 18:00:00 +0000
categories: [development, github, ai]
tags: [dotfiles, ai, github-copilot, agents, developer-tools, zsh, shell]
---

Every developer who has worked across multiple machines knows the pain of setting up a new environment from scratch. The dotfiles repository at [github.com/abuxton/dotfiles](https://github.com/abuxton/dotfiles) started as the answer to that problem — and has grown into something quite a bit more interesting.

## Where It All Started

The repository carries a badge in its description: **"inspired by [https://mths.be/dotfiles](https://mths.be/dotfiles)"** — a reference to [Mathias Bynens'](https://mathiasbynens.be/) legendary dotfiles collection. Mathias' dotfiles have been the starting point for countless developers' personal configurations, offering a thoughtfully curated set of macOS defaults, shell settings, and productivity aliases. They set the bar for what a modern dotfiles repository could be.

Building on that foundation, `abuxton/dotfiles` grew into something optimised for a specific workflow: **macOS and BSD, with ZSH as the primary shell** and simplified Bash fallback support. Over years of use, the configuration was refined, broken, fixed, and rebuilt — the natural lifecycle of a personal developer toolchain.

## The Traditional Dotfiles Era

For most of its life, the repository followed the classic dotfiles pattern:

- Shell configuration files (`.zshrc`, `.bash_profile`, `.bashrc`)
- A library of aliases in `.aliases` covering git, navigation, and daily tasks
- Shell function modules in `.functions.d/` organised by domain
- Profile management for optional tooling (GitHub, AWS, etc.)
- A `bootstrap.sh` to deploy everything onto a new machine

The setup was practical and proven. Two deployment scripts handled the full workflow: `bootstrap.sh` for first-time machine setup (git pull, oh-my-zsh, rsync deploy) and `setup.sh` for idempotent reconfiguration at any time. The validation script `validate-dotfiles.sh` kept things honest.

The project description puts it plainly: *".files, including `~/.macos`, refactored over years of usage and now something else."* That "now something else" is where the interesting story begins.

## The Shift: AI Agent Configurations Enter the Picture

In early 2026, the repository underwent a significant transformation. A flurry of pull requests through February and March 2026 tells the story clearly:

- **PR #7 — Feat/agent refactor** (25 Feb 2026): Added functionality to support agent configs. This was the turning point — introducing a dedicated `agents/` directory and the `deploy-agents.sh` script as a third step in the setup workflow.
- **PR #8 — Add co-pilot instructions** (25 Feb 2026): GitHub Copilot-specific configuration landed in the repository, reflecting the growing importance of AI assistant context in daily development.
- **PR #9/#10/#12 — Adding skills** (26–27 Feb 2026): A rapid series of PRs added and refined the skills framework, bringing in OpenSpec workflow skills, git workflow patterns, and domain-specific capabilities.
- **PR #14 — Feat/abc strap** (6 Mar 2026): Extended the `bootstrap.sh` setup to incorporate the new agent-aware workflow, completing the three-step setup model.

The net result: what was a two-script dotfiles repo became a **three-step environment setup** for the AI-assisted development era.

## The New Approach: A Three-Step Setup

The current workflow reflects this evolution directly:

```bash
bash bootstrap.sh       # Step 1: Sync repo, install oh-my-zsh, deploy dotfiles
bash setup.sh           # Step 2: Configure environment, symlinks, profiles
bash deploy-agents.sh   # Step 3: Deploy AI agent configurations
```

The third script, `deploy-agents.sh`, is a deliberate statement about where development tooling is heading. It deploys a centralised `~/.agents/` directory containing:

- **Skills** — reusable, structured instructions for AI agents (OpenSpec workflow, git patterns, domain knowledge)
- **Prompts** — agent-specific prompt templates
- **Commands** — CLI command definitions
- **Settings** — a central `settings.json` for agent configuration

Agent configurations are then symlinked for each supported platform: `~/.bob/`, `~/.claude/`, `~/.github/` (Copilot), and `~/.opencode/`. The `~/AGENTS.md` file provides a unified workflow reference for any agent, regardless of interface.

## The Role of the GitHub Copilot Coding Agent

The recent changes to the dotfiles repository are themselves a product of the workflow they describe. The GitHub Copilot coding agent was used to implement many of the recent improvements — a fitting meta-narrative.

The agent-assisted approach shifted how changes get made:

1. **OpenSpec workflow** — Changes are now driven by structured artifacts (proposal, specs, design, tasks) rather than ad hoc commits. The `openspec-new-change` and `openspec-apply-change` skills guide this process.
2. **Skills as reusable context** — Rather than re-explaining the project to an agent each session, the skills framework packages that context once. The agent knows the conventions, the deployment workflow, and the expected output format.
3. **Idempotency by design** — Both `setup.sh` and `deploy-agents.sh` are fully idempotent, making them safe to run repeatedly. This is as important for agent-driven changes as it is for human-driven ones — you can re-run scripts without fear of side effects.
4. **Validation as first-class concern** — The CI workflow validates repository structure, script syntax, POSIX compliance, and dry-run modes. Agents working on the repo operate in an environment that catches mistakes automatically.

## Why This Matters

Dotfiles have always been a personal productivity investment — a small upfront effort that pays dividends across every machine you ever configure. The shift towards agent-aware dotfiles represents the next evolution of that investment.

The skills framework in particular is worth noting. When your shell environment and your AI agent context are managed from the same repository, they reinforce each other. Shell aliases for git map neatly to the git workflow skill. The bootstrap sequence is documented in the README and encoded in the agent's understanding of the project.

The practical implication: a developer setting up a new machine with `abuxton/dotfiles` today doesn't just get a configured shell. They get a configured development environment that includes AI agents already oriented to their workflow, conventions, and tooling preferences.

## What's Next

The repository continues to evolve. The recent PRs suggest active exploration of the agent skills framework — refining which skills are bundled, how they're structured, and how they interact with the broader development workflow. The OpenSpec approach to change management is increasingly embedded in how the project itself is developed.

If you're interested in the dotfiles-as-developer-environment philosophy, the repository is worth exploring. Fork it, strip what you don't need, and adapt it to your own workflow — in the tradition of Mathias Bynens' original inspiration.

[github.com/abuxton/dotfiles](https://github.com/abuxton/dotfiles)
