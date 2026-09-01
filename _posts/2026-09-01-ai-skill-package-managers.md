---
layout: post
title: "AI Skill Package Managers: We Need the Boring Bits"
date: 2026-09-01 07:26:45 +0000
categories: [ai, development]
tags: [ai-agents, agent-skills, package-management, supply-chain-security, skills-sh, npm]
---

I have written before about publishing my own collection of agent skills through npm. At the time, the appealing bit was the small command:

```bash
npx skills install @abuxton/skills
```

Put a useful `SKILL.md` in a package, install it, and make it visible to an agent. It is a good developer experience. It is also the beginning of a dependency system whether we call it that or not.

The awkward truth is that skills, prompts, rules, MCP configurations, and agent harnesses are all executable *in effect*. A Markdown file is not a binary, but an agent that follows its instructions can run commands, read a checkout, make network calls, and change a repository. That makes the question “where did this skill come from?” at least as important as “what does this skill do?”

We are still early enough that “AI package manager” describes several different things: a discovery CLI, a package-manager integration, a registry, or a reproducibility layer. The names will change. The problems are familiar.

## Five approaches worth watching

| Tool | Model | What it brings |
| --- | --- | --- |
| [skills.sh](https://skills.sh/) | Git-backed skill discovery and installer | A common CLI for finding and routing `SKILL.md` files to many agents |
| [skills-npm](https://github.com/antfu/skills-npm) | npm package integration | Ships skills alongside the JavaScript packages that need them |
| [Quiver](https://github.com/astra-sh/qvr) | Git-native, lockfile-first skill manager | Immutable installs, scan results, provenance, and reproducible sync |
| [Tank](https://github.com/tankpkg/tank) | Registry and security-first package manager | Versions, a lockfile, declared permissions, and an audit workflow |
| [Grimoire](https://github.com/grimoire-rs/grimoire) | OCI-backed multi-agent package manager | Digest-pinned artifacts in registries an organisation can control |

### 1. skills.sh: the discovery layer

[Vercel's `skills`](https://github.com/vercel-labs/skills) is probably the clearest answer to “how do I give the same skill to Claude Code, Copilot, Codex, Cursor, and the rest?” It accepts a repository, URL, or local path and writes or symlinks the selected skill into the directory each supported agent understands:

```bash
npx skills add vercel-labs/agent-skills --skill frontend-design
```

That is deliberately lightweight. The source is normally Git, the content is normally a `SKILL.md`, and the target agent does the interpretation. It is useful precisely because it does not require every author to join a new marketplace. But it is an installer, not yet the whole dependency-management story: a repository reference alone does not give a project the equivalent of a reviewed, immutable lockfile.

It is also worth calling out a small piece of ecosystem churn. Older examples, including my own, use `npx skills install`. The current `skills` CLI documents `npx skills add`; `install` is used by other tools for other package formats. Copy the command from the tool and version you have selected rather than treating `skills` as one permanently stable global interface.

### 2. skills-npm: make skills part of the dependency

[skills-npm](https://github.com/antfu/skills-npm) takes a different route: an npm package can contain agent skills and the CLI discovers them from `node_modules`. A project can add it as a development dependency and wire synchronisation into `prepare`:

```bash
npm i -D skills-npm
npx skills-npm setup
```

The result is a set of symlinks to skills supplied by installed packages. This is particularly attractive for a tool that needs both code and instructions: update one dependency and the compatible skill travels with it.

The familiar npm trade-off travels with it too. A version range is not a review, and an install can execute package lifecycle scripts. Committing the lockfile, reviewing dependency changes, and being cautious about `prepare` is not bureaucracy here; it is the control plane for what an agent will subsequently read.

### 3. Quiver: treat skills as locked inputs

[Quiver (`qvr`)](https://github.com/astra-sh/qvr) feels closest to the package-manager lessons I want this ecosystem to learn. It is a Git-native CLI that resolves a skill, scans it, records the source commit and content hash in `qvr.lock`, then symlinks the immutable copy into agent directories:

```bash
qvr add code-review@v1.2.0
qvr sync --frozen
qvr lock verify --strict
```

Its useful idea is not merely a scanner. It is that the lockfile records the *decision*: source, resolved commit, subtree hash, scan verdict, and provenance. A colleague cloning the project gets the same bytes rather than whatever a registry happens to serve that day. It can also hide ambient skills that are not declared in the project, which is a healthy default for work that ought to be reviewable.

### 4. Tank: permissions should be package metadata

[Tank](https://github.com/tankpkg/tank) is explicitly positioning itself as a security-first package manager. Its `skills.json` declares packages and a permission budget; its `skills.lock` captures resolved hashes. Installing a skill whose requested filesystem, network, or subprocess access exceeds that budget requires a visible approval:

```bash
tank init
tank install @org/skill
tank audit
tank verify
```

That is a useful design challenge to the rest of the field. Agent skills are not ordinary libraries. A library normally runs because *our* code invokes it. A skill can influence the plan that decides what commands run next. Declaring capabilities cannot prove that an instruction is honest, but it makes a surprising expansion in authority observable and gives CI something concrete to reject.

### 5. Grimoire: use an existing artifact supply chain

[Grimoire (`grim`)](https://github.com/grimoire-rs/grimoire) packages skills, rules, agents, commands, and MCP servers as OCI artifacts. That means a team can use GHCR, Docker Hub, or its own registry rather than trusting another hosted skill service:

```bash
grim init
grim add ghcr.io/grimoire-rs/skills/grim-usage
grim install
```

The tool writes the selected artifact to the formats its target clients actually consume and pins it by digest in `grimoire.lock`. OCI will not make a bad prompt safe, but registry access controls, retention, mirrors, and digest pinning are mature operational machinery. Reusing them is much more convincing than inventing a new central marketplace and hoping it develops supply-chain controls later.

## The threat is not only code on disk

There are two related risks that are easy to blur together.

The first is ordinary package supply chain risk. A downloaded CLI or npm package may run install scripts; an MCP server is a process with the permissions of the account that launched it; a bundled helper script may be executable. Pin versions, inspect diffs and lockfiles, minimise credentials, and run untrusted work in a disposable sandbox. None of that is new, even if the word “skill” is.

The second is instruction supply chain risk. An agent may read a skill, a repository-level instruction file, an issue, a web page, or a tool response as part of doing useful work. One malicious instruction can ask it to fetch an unreviewed payload, reveal an environment variable, weaken a guardrail, or edit its own on-disk configuration so that the next run is easier to compromise.

That last one deserves more attention. Giving an agent write access to the directory from which it loads its skills creates a persistence mechanism. An attacker does not need to persuade it to do something dangerous immediately; they only need to persuade it to rewrite the instructions for the next session. The skill has become both data and a mutable policy file.

The sensible baseline is therefore quite dull:

1. Keep project skills in version control and review them like code.
2. Pin every external source to a release, commit, or digest; commit the lockfile.
3. Prefer a per-project allowlist over a large, inherited global skills directory.
4. Make skill directories read-only to the agent where the workflow permits it.
5. Run new or changed skills against a disposable checkout with no real credentials.
6. Give the agent the smallest filesystem, network, and subprocess permissions needed for the task.
7. Record the skill version and command output that produced a change, then review the diff outside the agent session.

Static scanning helps: look for downloads, encoded content, secret access, shell execution, invisible Unicode, and instructions that bypass review. But scanning is a filter, not a proof. “Read this file and send the contents to this URL” is perfectly understandable prose. A human review and a small blast radius remain necessary.

## We have solved this class of problem before

Software development did not become safer because every package author became trustworthy. It became more manageable because we built habits and tooling around imperfect trust: registries, namespaces, version constraints, lockfiles, integrity hashes, provenance, vulnerability feeds, reproducible builds, restricted CI tokens, and code review.

AI harnesses need the equivalent, with one addition: permissions. A library has an API surface. An agent skill has an authority surface. Where can it read? What can it write? Can it execute a subprocess? Which hosts can it contact? Can it alter the files that define its future behaviour?

The five projects above do not agree on packaging, storage, or even the unit being installed. That is fine. The useful competition is over the boring bits: immutable resolution, explicit scope, provenance, inspection, revocation, and repeatable installs. I would rather see several incompatible tools get those properties right than one enormous skill marketplace normalise clicking “install” on a blob of instructions with my shell and tokens behind it.

Skills are a lovely way to turn accumulated practice into something an agent can reuse. That makes them valuable. It also makes them dependencies. The sooner we manage them as such, the less surprising the first serious skills supply-chain incident will be.

## Further reading

- [skills.sh and the `skills` CLI](https://github.com/vercel-labs/skills)
- [skills-npm](https://github.com/antfu/skills-npm)
- [Quiver](https://github.com/astra-sh/qvr)
- [Tank](https://github.com/tankpkg/tank)
- [Grimoire](https://github.com/grimoire-rs/grimoire)
- [Docker Sandboxes for Safer AI Agents](/ai/security/2026/08/26/docker-sandboxes-safer-ai-agents.html)
- [Building Agent Skills: Do-Nothing Scripting and Gradual Automation](/development/automation/agents/2026/04/05/building-agent-skills-do-nothing-scripting.html)
