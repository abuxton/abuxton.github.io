---
layout: post
title: "Keeping the Lights On in the AI Software Factory"
date: 2026-11-08 09:04:13 +0000
categories: [ai, development]
tags: [ai-agents, software-factories, software-engineering, code-review, agent-skills]
---

The latest argument about AI-assisted development often arrives wearing a hard hat and carrying a diagram of a factory. It promises loops, harnesses, queues, agents, and enough throughput to make a small engineering team feel like it has discovered industrialisation. This is exciting right up to the point where somebody has to explain why an unread change broke production.

That somebody remains us.

I have been reading Addy Osmani's recent writing on [owning the outer loop](https://addyosmani.com/blog/own-the-outer-loop/), [software factories](https://addyosmani.com/blog/software-factories/), [human judgement](https://addyosmani.com/blog/human-judgment-doesnt-leave-the-software/), and [auditing agent files](https://addyosmani.com/blog/audit-your-agent-files/). Taken together, they make a convincing case that the useful question is not whether agents can generate more code. They plainly can. The useful question is whether we still understand, verify, and own what arrives at the other end.

## The factory has a gate for a reason

Osmani describes a loop as an agent gathering context, taking an action, checking the result, and repeating. A harness supplies the walls around that loop: tools, memory, sandboxing, permissions, and the definition of done. A software factory is what happens when many harnessed loops work from a queue and feed their results through a review gate.

That is a helpful model because it removes some of the magic. A factory is not a giant, wise agent. It is an operating model. It has inputs, controls, outputs, failure modes, and a queue that will cheerfully become a queue of expensive mistakes if left unattended.

The distinction between a *light* and *dark* factory is especially useful. In a dark factory, machines create and ship changes with no human reading the details. In a light factory, people still decide where attention matters: product intent, architecture, a risky diff, a public API, a production incident. The lights are not there because humans enjoy staring at every line of CSS. They are there because some decisions are too costly, subtle, or long-lived to delegate merely because a test suite became green.

Green is useful. Green is not a moral character reference.

## Agents run the inner loop; people own the outer one

The phrase "outer loop" puts a useful boundary around the work. Agents can investigate a problem, propose a plan, make a change, run checks, and produce a report. That is valuable inner-loop work. The outer loop is deciding whether the problem is worth solving in that way, whether the evidence is credible, whether the change should ship, and who will deal with the consequences if it does not.

This is not an argument for putting a human approval button at the very end of an otherwise unexamined conveyor belt. It is an argument for bringing judgement upstream. A short review of intent, scope, constraints, and acceptance criteria can save everyone from reviewing two thousand lines of confidently generated enthusiasm later. There is a reason a clear GitHub issue, a small branch, a testable change, and a reviewable pull request remain deeply unfashionable but stubbornly useful.

The practical constraint is not generation. It is verification. Agents can produce work faster than a person can absorb it, and our attention does not become parallel merely because the tabs do. Good types, focused tests, static analysis, isolated environments, narrow permissions, and useful logs create evidence that makes review cheaper. They do not remove the need for judgement; they reserve it for the parts that need it.

That also means a factory is not automatically the next level of adulthood for every project. As Osmani notes in [his discussion of human judgement](https://addyosmani.com/blog/human-judgment-doesnt-leave-the-software/), a solid coding harness, good specifications, sensible constraints, and human involvement can take a team surprisingly far. A factory earns its scaffolding when work must be repeatable, event-driven, and safely handed between runs. Otherwise, one can end up automating the administration of a problem that did not need a production line in the first place.

## The instructions are part of the machine

There is a less glamorous part of this picture: the markdown files, skills, hooks, permissions, memories, and MCP connections that instruct an agent what it may do. They are not decoration. They are part of the harness, which means they are part of the system that is making changes on our behalf.

In [Audit your Agent files](https://addyosmani.com/blog/audit-your-agent-files/), Osmani makes the important point that configuration has a half-life. Models change, repositories change, tools gain capabilities, and the rule added after one particularly annoying incident quietly becomes permanent constitutional law. Add enough of those rules and a concise decision guide turns into a small library with no librarian. The agent may follow less of it, the context costs more, and nobody is quite sure which instruction is still carrying real weight.

This is not a case for deleting every skill in a burst of minimalist virtue. Useful skills, project guidance, and safety constraints can carry hard-won knowledge. It is a case for asking each one to earn its place:

- What specific risk or repeated task does this instruction address?
- Can the rule be enforced better by a test, hook, permission, or branch protection rule?
- Does it duplicate the source code, README, or another instruction?
- Can a new contributor explain why it exists?
- What would tell us that it has stopped helping?

The answer to the last question matters. Configuration without an audit cadence is how a harness becomes a loft full of mystery cables. Keep a recoverable record, test removal where it is safe, and retain the rules that demonstrably improve the work. The goal is not a perfectly empty configuration. It is a legible one.

## Keeping the lights on is an engineering choice

The enjoyable bit of the factory metaphor is the scale. The important bit is the switchboard. Each loop needs a deliberate answer about its autonomy: can an independent check prove the result, how quickly can it do so, what is the blast radius if it is wrong, and who has enough context to approve it?

Some work can quite reasonably run in the dark. A tightly bounded formatting change with deterministic checks is not the same proposition as a database migration, authentication change, billing workflow, or public interface. Treating every task as equally safe is as unhelpful as treating every task as equally terrifying. The skill is deciding where the lights need to stay on and revisiting that decision as the codebase and evidence improve.

That is why this is ultimately an optimistic view of agentic development. The role of the engineer does not vanish into a pile of prompts. It moves towards clearer boundaries, better evidence, stronger constraints, and more deliberate ownership. We get to spend less time typing the first draft and more time deciding what deserves to exist, how it should behave, and whether we are willing to put our name on it.

The machines can work quickly in the dark. The rest of us should make sure we can still find the light switch.

## Further reading

- Addy Osmani, [Own the Outer Loop](https://addyosmani.com/blog/own-the-outer-loop/)
- Addy Osmani, [Software Factories, Light and Dark](https://addyosmani.com/blog/software-factories/)
- Addy Osmani, [Human Judgment Doesn't Leave the Software](https://addyosmani.com/blog/human-judgment-doesnt-leave-the-software/)
- Addy Osmani, [Audit your Agent files](https://addyosmani.com/blog/audit-your-agent-files/)
- [Addy Osmani's blog](https://addyosmani.com/blog/)

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
