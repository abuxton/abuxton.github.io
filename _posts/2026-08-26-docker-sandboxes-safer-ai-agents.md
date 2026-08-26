---
layout: post
title: "Docker Sandboxes for Safer AI Agents"
date: 2026-08-26 10:07:58 +0000
categories: [ai, security]
tags: [agents, docker, sandboxes, sbx, npm, supply-chain-security, agent-skills]
---

I owe you an apology for the quiet August. I have not posted much because personal life took priority: I got married. It was a very good reason to step away, but it is still nice to be writing again.

The article [Running AI Coding Agents Safely: A Hands-On Guide to Docker Sandboxes (SBX)](https://collabnix.com/running-ai-coding-agents-safely-a-hands-on-guide-to-docker-sandboxes-sbx/) is a useful prompt to revisit how we run coding agents. Its central idea is simple: give an agent a disposable Docker environment rather than unrestricted access to the developer workstation.

That is not a complete security boundary, but it is a meaningful reduction in blast radius.

## Why agent execution is different

A coding agent is not just an editor with autocomplete. It can read a repository, execute shell commands, install packages, run tests, make network requests, and alter files. A workflow can also load instructions from a repository, an extension, an MCP server, or an agent skill. The useful automation and the dangerous capability are the same capability viewed from different angles.

The risk is amplified by software supply chains. An npm package can run lifecycle scripts during installation. A package that looks harmless can therefore read environment variables, search a checkout, exfiltrate credentials, or modify generated files before a human reviews the dependency. The same concern applies to a downloaded `SKILL.md`: prose is not executable by itself, but it can persuade an agent to execute a command with the permissions available to that agent.

Recent npm compromises have made this threat model less theoretical. The question is no longer only “is this package popular?” It is also “what can the process that consumes this package reach?”

## What SBX changes

The Collabnix walkthrough presents Docker Sandboxes (SBX) as a way to run an AI coding agent in a containerised, ephemeral workspace. The important security properties are the defaults and the boundaries around the agent:

- **A separate filesystem** limits accidental edits and prevents a prompt from turning into a tour of the whole home directory.
- **Explicit mounts** make the repository and any other shared data deliberate decisions rather than ambient access.
- **Controlled networking** gives a place to deny package downloads, narrow egress, or route traffic through an observable proxy.
- **Disposable environments** make resetting after an untrusted install or a suspicious instruction cheap.
- **Reproducible setup** turns the agent environment into something that can be reviewed and rebuilt instead of a mysterious long-lived workstation.

This is a good fit for agent workflows because the unit of work is already bounded: check out a branch, ask the agent to make a change, inspect the diff, run validation, and throw the environment away. SBX makes the boundary part of that loop.

## The boundary is not magic

“It runs in Docker” is not the same as “it is safe.” A container with the Docker socket mounted, broad host mounts, privileged mode, or unrestricted credentials can still be a powerful path back to the host. A sandbox also cannot rescue a secret that was deliberately copied into the workspace, or a human who merges an unreviewed change.

I would treat SBX as a risk-reduction layer, not a verdict:

1. Start with no credentials and no host socket.
2. Mount only the checkout or a purpose-built working copy.
3. Keep network access off unless the task needs it.
4. If network access is required, allow only what is needed and log it.
5. Run as a non-root user with a read-only base image where practical.
6. Review the resulting diff, dependency changes, and command output outside the agent session.
7. Destroy and recreate the sandbox when trust changes.

The last point matters. A sandbox is most useful when it is treated as cattle, not as a pet that accumulates tokens, caches, and exceptions.

## Trojanised skills are a workflow problem

The [NHI community guidance on trojanized AI skills](https://nhimg.org/community/nhi-breaches/trojanized-ai-skills-what-practitioners-need-to-do-now/) makes the complementary point: practitioners need to treat agent skills as untrusted supply-chain inputs. A skill can contain helpful instructions and still include a step that weakens controls, uploads data, or fetches and executes another payload.

The right response is not to stop using skills. It is to make them reviewable and constrain what they can do:

- Pin skills to a known commit or release and review changes like code.
- Prefer small, single-purpose skills over opaque “do everything” bundles.
- Do not put secrets in prompts, skill files, or the workspace by default.
- Search for shell execution, downloads, encoded payloads, credential access, and instructions to bypass review.
- Test a skill with a disposable repository and deliberately fake credentials.
- Keep the agent's tool permissions narrower than the permissions of the human account.
- Record which skill and version was used for a change.

This is also where the npm ecosystem connection becomes clear. A malicious package, an MCP server, and a trojanized skill are different delivery mechanisms for the same class of problem: software or instructions that cause an automation system to exercise authority on someone else's behalf. SBX cannot tell whether an instruction is honest. It can make the consequences of a bad instruction smaller.

## A practical SBX workflow

For a small change, my preferred workflow would look like this:

1. Create a clean, short-lived branch and a working copy with no personal credentials.
2. Start SBX with the smallest repository mount and a non-privileged user.
3. Ask the agent to explain its plan before it runs commands.
4. Allow network access only for a named requirement, such as installing a pinned dependency.
5. Capture the command history and inspect package lifecycle output.
6. Run tests and static checks in the sandbox, then inspect the diff from the host.
7. Reject unexpected files, lockfile changes, outbound requests, or permission changes.
8. Remove the sandbox and recreate it for the next task.

The deliberate friction is a feature. If a task cannot be completed without handing an agent a long-lived cloud token or the Docker socket, that is useful information about the task design.

## What I would add to the article

The hands-on guide is strongest as an introduction to the mechanics. For production use, I would add an explicit threat-model table for mounts, network, credentials, Docker daemon access, and persistence. It would also help to show a deliberately malicious npm install or skill in a toy repository, then demonstrate which evidence remains visible after the sandbox is destroyed.

That kind of exercise avoids the false comfort of a green prompt. Security controls should be tested with the same care as the agent's code.

## The useful conclusion

Agents are becoming part of the software supply chain, whether we give them that title or not. They consume packages, instructions, tools, and repositories, then act with whatever authority we leave available.

Docker Sandboxes offer a practical place to put a boundary around that authority. They do not replace dependency pinning, skill review, least privilege, network controls, or human review. They make those practices more achievable by giving us a clean reset point and a smaller failure domain.

For me, that is the compelling part of SBX: not “the agent is trusted,” but “the next task does not inherit the last task's trust.” That is a much healthier default for agentic development.

## Further reading

- [Running AI Coding Agents Safely: A Hands-On Guide to Docker Sandboxes (SBX)](https://collabnix.com/running-ai-coding-agents-safely-a-hands-on-guide-to-docker-sandboxes-sbx/) — the article reviewed here
- [Trojanized AI Skills: What Practitioners Need to Do Now](https://nhimg.org/community/nhi-breaches/trojanized-ai-skills-what-practitioners-need-to-do-now/) — guidance on reviewing agent skills
- [npm package.json scripts](https://docs.npmjs.com/cli/v11/using-npm/scripts) — why install-time scripts belong in the threat model
