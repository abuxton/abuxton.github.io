---
layout: post
title: "Agent Harnesses Need the Boring Practices Too"
date: 2026-09-06 08:44:17 +0000
categories: [ai, development]
tags: [ai-agents, agent-harnesses, developer-environments, package-management, supply-chain-security, reproducibility]
---

There is a slightly strange gap in the current agentic-coding conversation.

We are getting very good at talking about prompts, models, context windows, skills, MCP servers, and whether an agent should plan before it starts changing files. We are much less good at talking about the boring machinery around them: the clean checkout, the pinned dependency, the disposable environment, the setup script, the lockfile, and the boundary between one task and the next.

That machinery is not glamorous. It is also where a lot of the safety is.

I have been thinking about this while reading the [MIT Missing Semester notes on package management](https://missing.csail.mit.edu/2019/package-management/), the [Apptension Developer Handbook](https://github.com/apptension/developer-handbook), and a growing pile of agent guidance from [Tweag](https://tweag.github.io/agentic-coding-handbook/), [Google Cloud](https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system), and [Claude Code](https://code.claude.com/docs/en/best-practices). They are written for slightly different purposes, but they keep arriving at versions of the same answer: make the work bounded, explicit, repeatable, and observable.

That is not an agentic invention. It is just good development practice, finally becoming hard to ignore.

## The agent is part of the environment

A coding agent is not merely writing text into an editor. It is usually reading a repository, following instructions, running shell commands, installing dependencies, calling tools, and changing files. Once it can do those things, its environment is part of the system design.

The important question is not only *what model are we using?* It is also:

- What repository and branch can it see?
- Which instructions, skills, plugins, and MCP servers does it load?
- What can it read, write, execute, or send over the network?
- Which credentials have happened to be left in the environment?
- What survives when this task ends?

If the answer is “my normal machine, with all the usual configuration,” we have made a very powerful assistant inherit an accidental history of trust.

That is the thing I keep coming back to. A long-lived development machine accumulates useful stuff: caches, global tools, SSH keys, browser sessions, shell history, credentials, experimental scripts, and the little exceptions that got us unblocked last Tuesday. An agent does not need to be malicious for that to be a problem. It only needs to act confidently in an environment that is much broader than the task deserved.

This is why I argued for [Docker sandboxes](/ai/security/2026/08/26/docker-sandboxes-safer-ai-agents.html) as a practical boundary. A container is not magic security dust, especially if we give it host mounts, a Docker socket, root access, and all our tokens. But a short-lived workspace with a small mount, no ambient credentials, a non-privileged user, and controlled network access is a far better starting point than an agent living in the same messy house as everything else.

The useful property is not “the agent is trusted.” It is “this task does not inherit the trust of the previous task.”

## We already know how to do the boring bits

The Missing Semester package-management chapter is a good reminder that package managers exist to make software installation reproducible and maintainable. A project should be able to say what it depends on, which version was resolved, and how another developer can obtain the same working setup. Virtual environments and project-local tooling are not ceremony for its own sake; they stop one project's needs leaking into another's.

Reproducibility should not mean immobility. Projects evolve by updating a declared dependency, image, skill, or instruction deliberately; regenerating and reviewing the lockfile; validating the change in a clean environment; and retaining a known-good version to which they can return. The same discipline that makes an npm upgrade explainable can make a change to an agent skill or harness explainable.

The same idea applies to agentic work, only the inputs are wider now. A project may depend on:

- language packages and system tools;
- a development container, VM image, or reproducible setup command;
- repository instructions and agent configuration;
- skills, prompts, plugins, hooks, and MCP servers;
- a model or provider configuration; and
- the permissions the harness grants to all of the above.

Some of these are code and some are Markdown, but that distinction is less reassuring than it sounds. A `SKILL.md` does not execute by itself; an agent following it may execute plenty. The [post I wrote about AI skill package managers](/ai/development/2026/09/01/ai-skill-package-managers.html) made the same point: skills and instructions are dependencies with an authority surface, so they need provenance, pinning, review, and a way to reproduce the decision.

This is where project templates and harnesses can earn their keep. A template should not only create directories and a README. It should give a new project a known path to:

1. create a clean environment;
2. install dependencies from committed manifests and lockfiles;
3. run formatting, tests, and builds through named commands;
4. configure an agent with task-appropriate permissions;
5. keep temporary output inside the project or a disposable workspace; and
6. tear the environment down when the work is done.

That can be a devcontainer, a Docker image, Nix, a VM, a Makefile, or a package-manager command. The implementation matters less than the property: “clone this repository and run the documented setup” should be more reliable than “install whatever I have globally and copy the instructions from my home directory.”

The Apptension handbook is useful here precisely because it is not written as an AI manifesto. It treats onboarding, agreed conventions, pull-request review, protected branches, checking a failed build before merging, and careful credential handling as ordinary professional practice. Agents do not make those things obsolete. They make the cost of not having them much more visible.

## A harness should be a control plane, not a bag of prompts

The word *harness* can sound needlessly grand. I mean the layer that gives an agent its job, tools, context, permissions, and feedback loop. It is the bit that says: use this checkout, follow these versioned instructions, run these commands, ask before doing this, and show the human the resulting diff.

Tweag's [Agentic Coding Handbook](https://tweag.github.io/agentic-coding-handbook/) is valuable because it puts emphasis on engineering process rather than pretending that a better prompt is a replacement for one. Google's [agentic AI design-pattern guidance](https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system) makes a similar architectural point: choose patterns according to the work, with evaluation, observability, and appropriate controls rather than autonomous behaviour as the default setting. Claude Code's [best practices](https://code.claude.com/docs/en/best-practices) are equally practical: give the tool clear context, keep work scoped, use project instructions, and verify the result.

They are not all making the same argument:

| Source | Its useful question | Harness implication |
| --- | --- | --- |
| Tweag | How do people work effectively with coding agents? | Keep tasks small, use specifications, and retain code review. |
| Google Cloud | Does this task need an agent at all, and how much autonomy does it deserve? | Start with the smallest pattern that fits; add agents, tools, and permissions only when the work requires them. |
| Claude Code | How does an agent complete repository work reliably? | Version the context, provide a command that verifies the result, and make the resulting evidence reviewable. |

Together, they describe the layers of a sensible harness: choose the right amount of autonomy, give it a bounded job and context, and require evidence before declaring it finished.

None of that requires a giant platform. A modest harness for a repository can be enough:

- version-control the project instructions alongside the code;
- begin each task from a clean checkout or disposable copy;
- use the project’s package manager and lockfile rather than global installs;
- expose a small, documented set of build and test commands;
- default to no secrets, no privileged host access, and no broad network access;
- make permission changes visible and time-limited;
- log commands and review the diff and dependency changes outside the agent; and
- discard the workspace, or reset it to a known state, after the task.

That is a development environment with an agent in it, not an agent left to assemble a development environment from whatever it discovers on disk.

## Reuse should mean reuse of the recipe

There is a temptation to reuse agent configuration by accumulating it in a global directory. It feels efficient: install more skills, teach the agent more preferences, add more integrations, and let every future session inherit the lot.

It is efficient right up to the point where nobody can explain why a particular agent had a particular instruction, where it came from, or what it is now allowed to do.

My earlier post on [refactoring agent workflows](/development/agents/2026/03/09/refactoring-agent-workflows.html) was mostly about reducing process overhead. I still think a lightweight Plan → Tasks → Implementation loop is the right shape for small work: a scoped task, named checks, and a reviewable diff make a useful evidence trail. But simplicity is not the same as invisible state. A short plan is easier to review when the environment that executes it is also understandable.

The useful kind of reuse is a repository template, an image definition, a setup command, a versioned skill package, and a lockfile. Those are recipes other people can inspect, reproduce, update deliberately, and roll back. The dangerous kind is a personal agent directory slowly becoming a second, undocumented operating system.

There is a security angle too. If an untrusted repository, issue, web page, or skill can persuade an agent to alter the files it loads next time, a one-off instruction becomes persistence. Keeping project-level configuration versioned and making agent-readable policy read-only where possible turns that from a hidden mutation into a reviewable change.

## The human learning problem

AI has lowered some very real gates. That is often good. Someone who could not previously get past the first wall of syntax, tooling, and unfamiliar terminology can now make a small application, automate a boring task, or contribute a patch. I do not want to romanticise those gates just because I had to climb them.

But those old gates also contained lessons about environment hygiene: why we isolate dependencies, why we do not run random commands as an administrator, why a clean build matters, why a lockfile is worth committing, why code review exists, and why deployment credentials do not belong in a local `.env` copied into every experiment.

The current tool marketing is very good at helping people jump over the gates. It is much less consistently good at rebuilding the guardrails on the other side. New developers can now be given an agent that cheerfully installs packages, accepts instructions, creates cloud resources, and publishes changes before they have had a chance to learn what those actions mean. When security exploits and dubious “copy this prompt” workflows circulate through social media, that gap stops being academic.

This is not an argument for blaming people who are new to development. It is an argument for tool builders and experienced developers to stop treating safe defaults as advanced-user features. The harness should teach the practice by making the safe path the easy path: start clean, declare inputs, grant less, inspect changes, and reset.

## Not a return to gatekeeping

There is a bad version of this argument which says that only people who have spent years manually configuring toolchains deserve to use AI. I do not believe that at all.

The better goal is to package the good practice. Give people templates that come with reproducible setup. Give them project-local agent configuration instead of a scavenger hunt across a home directory. Give them a preview of what the agent will change, a clear approval point for new access, and a clean environment they can destroy without losing their work.

We should be using the automation to make professional habits more accessible, not to hide them until something goes wrong.

The agentic future does not need fewer harnesses. It needs better ones: boring, inspectable, disposable, and built from the lessons software development has already learned the hard way.

## Further reading

- [The Missing Semester: Package Management](https://missing.csail.mit.edu/2019/package-management/)
- [Apptension Developer Handbook](https://github.com/apptension/developer-handbook)
- [Tweag Agentic Coding Handbook](https://tweag.github.io/agentic-coding-handbook/)
- [Google Cloud: Choose a design pattern for an agentic AI system](https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system)
- [Claude Code: Best practices](https://code.claude.com/docs/en/best-practices)
- [Docker Sandboxes for Safer AI Agents](/ai/security/2026/08/26/docker-sandboxes-safer-ai-agents.html)
- [Refactoring Agent Workflows](/development/agents/2026/03/09/refactoring-agent-workflows.html)
- [AI Skill Package Managers: We Need the Boring Bits](/ai/development/2026/09/01/ai-skill-package-managers.html)
