---
layout: post
title: "Building Agent Skills: Do-Nothing Scripting and Gradual Automation"
date: 2026-03-16 16:10:13 +0000
categories: [development, automation, agents]
tags: [skills, do-nothing-scripting, automation, github-copilot, go, bash, agentskills]
---

There is a repository I have been quietly building called [abuxton/Skills](https://github.com/abuxton/Skills). It is a collection of agent skills — instruction files for coding agents like GitHub Copilot — built following the [agentskills.io specification](https://agentskills.io/specification) and published via npm as `@abuxton/skills`. This post is an attempt to document where it came from, where it is now, and one particular skill that I find genuinely interesting: `do-nothing-scripting`.

## What Are Agent Skills?

The basic idea is simple. A skill is a Markdown instruction file (`SKILL.md`) that a coding agent — Copilot, Claude, or any agent that discovers local files — can find and apply to a task. Each skill lives in its own directory under `skills/`:

```
skills/
└── do-nothing-scripting/
    ├── SKILL.md
    └── references/
        ├── do_nothing_template.sh
        └── extract_commands.py
```

The `SKILL.md` sets out a role, a workflow, and any supporting context the agent needs. The agent reads it and applies it. No special tooling, no APIs — just files and instructions.

The project started small. The [first skill](https://github.com/abuxton/Skills/commit/9fdc2188b58aff1ec879e5baf400b407b72c1c4e) was `shields-badges`, added in late February 2026 to automate applying consistent [shields.io](https://shields.io) badges to repositories. That was the first problem I wanted to solve, and a skill felt like the right shape for it.

Within a week, the repository had grown to include eight skills:

| Skill | What it does |
| ----- | ------------ |
| `shields-badges` | Identifies a repo's tech stack and applies appropriate badges |
| `writing-skills` | Authors new agent skills following the agentskills.io spec |
| `publishing-npm` | Publishes the skills package to npm |
| `github-gist` | Manages GitHub Gists via the `gh` CLI |
| `gitattributes-manager` | Creates and updates `.gitattributes` files conservatively |
| `xkcd-says-what` | Fetches relevant XKCD comics for docs or terminal output |
| `asciinema-record` | Records terminal sessions and optionally converts them to GIFs |
| `do-nothing-scripting` | Derives a do-nothing script from a recording, text file, or interview |

The npm publishing piece is worth noting. Using [skills-npm](https://github.com/antfu/skills-npm), the whole collection is installable with:

```bash
npx skills install @abuxton/skills
```

Which creates symlinks in your project's `skills/` directory, making the skills immediately discoverable to any agent working in that project. It is a surprisingly clean distribution mechanism for what are ultimately just Markdown files.

## The Do-Nothing Scripting Pattern

The `do-nothing-scripting` skill deserves its own section.

In 2019, Dan Slimmon wrote a post called [Do-nothing scripting: the key to gradual automation](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/) that I have thought about many times since reading it. The central idea is disarmingly simple: if you have a manual procedure — something you follow step by step — write a script that *does not automate anything*, but instead walks you through each step interactively, printing the instruction and waiting for you to confirm before moving on.

A do-nothing script looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

wait_for_enter() {
  read -rp "Press Enter to continue..."
}

step_create_feature_branch() {
  echo "==> Step 1: Create feature branch"
  echo "  Run: git checkout -b feature/my-change"
  wait_for_enter
}

step_update_config_file() {
  echo "==> Step 2: Update the config file"
  echo "  Edit config/settings.yml and set version to the new release number"
  wait_for_enter
}

main() {
  step_create_feature_branch
  step_update_config_file
  echo "✓ Done."
}

main "$@"
```

It does nothing. It runs no commands. It just prints and waits.

The reason this is clever is what happens *next*. Each step is a function. When you are finally ready to automate step one — when you have confidence that `git checkout -b feature/my-change` is always the right thing to do — you rewrite that function to actually run the command. The rest of the script is unchanged. You have moved from fully manual to partially automated in a way that is incremental, reversible, and transparent.

The `# TODO: automate` comment convention — added to any function whose body is a single deterministic command — marks the low-hanging fruit. It is a to-do list embedded in the script itself.

Slimmon's insight is that the gap between "I have a documented procedure" and "I have a script that does this" is often not as large as it feels. The do-nothing script is the bridge.

## The Skill

Translating this pattern into an agent skill required deciding what *inputs* the skill would accept. The original blog post imagines a human writing the script manually. But if you have an agent, you might have other sources:

- An **asciinema recording** of yourself running the procedure
- A **text file** with one step per line
- Your recent **shell history**
- No file at all — just a **conversation** where you describe the steps

The `do-nothing-scripting` skill supports all four modes. It uses a Python helper (`references/extract_commands.py`) to parse whichever format you provide, groups the extracted commands into named logical steps, and then generates the do-nothing bash script from a template.

The template enforces good practices by default: `set -euo pipefail`, named step functions, a `collect_context()` function for values that vary between runs (usernames, environment names, ticket IDs), and the `# TODO: automate` annotation for trivially-automatable steps.

It is a skill that produces an output that itself lowers the cost of future work. That feels like the right shape for an automation tool.

## PR #16: The Go Library Refactor

There is an [open pull request](https://github.com/abuxton/Skills/pull/16) — opened today, currently a draft — that aims to update the `do-nothing-scripting` skill to incorporate the [`danslimmon/donothing`](https://github.com/danslimmon/donothing) Go library.

Dan Slimmon did not just write about the pattern; he also wrote a Go library that implements it. The library provides a `Procedure` type with named `Step` values and a `Run()` method that handles the interactive prompting. A do-nothing script in Go using the library looks structurally similar to the bash version but benefits from type safety, real error handling, and the Go toolchain.

The PR checklist captures what the refactor involves:

- A new Go template (`references/do_nothing_template.go`) that uses the `danslimmon/donothing` library
- Updates to the skill instructions to present Go as the preferred implementation and bash as a maintained alternative
- New eval cases to validate agent outputs against the Go approach
- Documentation updates in both `README.md` and `AGENTS.md`

This is still in progress. The PR is a draft; the template and skill updates have not landed yet. But the direction is interesting: the bash approach is universal (no toolchain required), while the Go approach brings better structure for any procedure that will eventually grow beyond a few steps.

The decision to keep both as options rather than replacing one with the other seems right. Different contexts warrant different tools. A quick operational runbook probably stays as bash. A multi-stage release procedure with real error handling might warrant Go.

## The Broader Project

The Skills repository is, in some ways, an experiment in whether there is a useful middle layer between "I have a capable coding agent" and "I have a capable coding agent that knows how I work."

The agentskills.io specification and the skills-npm tooling provide the distribution mechanism. The repository provides the content. The individual `SKILL.md` files are the accumulated decisions about how each task should be approached: what inputs to accept, what output to produce, what edge cases to handle, what principles to apply.

What I find interesting in retrospect is that the project itself follows the do-nothing scripting principle. It started with documented procedures (skill instructions) that the agent would walk through manually with me. Some of those steps have since been automated — the npm publishing workflow, the shields badge application, the git attributes management. Others remain manual, which is fine.

Gradual automation. Start with documentation. Replace steps one at a time when you have confidence.

It is good advice for writing scripts. It turns out it is also a reasonable way to build a skills repository.

---

The skills package is available at [npmjs.com/package/@abuxton/skills](https://www.npmjs.com/package/@abuxton/skills). The repository is at [github.com/abuxton/Skills](https://github.com/abuxton/Skills). PR #16 tracking the Go library integration is at [github.com/abuxton/Skills/pull/16](https://github.com/abuxton/Skills/pull/16) — it will be worth revisiting once the draft is complete.

