---
layout: post
title: "AI Ethics After Asimov: Rules Are Not Enough"
date: 2026-05-17 20:15:28 +0000
categories: [ai, governance]
tags: [ai-ethics, asimov, ai-safety, governance, agents, llm, policy, instructions]
---

I spent some time with [AI Ethics - Asimov](https://dkasenberg.github.io/ai-ethics-asimov/), and it is worth reading slowly.

The core point is uncomfortable but right: Asimov's Three Laws are brilliant fiction, but weak governance. They are elegant as a storytelling device and deeply unreliable as an operating model for real systems. They are ambiguous, they clash with each other, and they quietly assume clean intent, clean context, and clean interpretation. Real systems get none of those for free.

That framing matters right now because we keep drifting toward a familiar mistake: treating "AI ethics" as if it can be solved by writing a short principles list and feeling reassured afterwards.

## What the post gets right

My reading of the piece is that it is less anti-ethics and more anti-handwaving.

It argues that the Asimov pattern gave us a cultural habit of searching for universal, elegant rules that magically resolve moral complexity. In practice, ethics in AI is not a static rulebook problem. It is a socio-technical systems problem: incentives, institutions, accountability, review processes, failure modes, and power.

That distinction is exactly where a lot of modern AI governance still struggles.

We publish principles. We ship products. We discover too late that principles without enforcement are mostly branding.

## Why instruction files now sit in the middle of this

In agentic systems, instruction files (whether you call them `AGENTS.md`, policy files, or platform-level system instructions) are increasingly where ethics gets operationalised.

That is good news and bad news at the same time.

Good news: we can encode boundaries directly in the execution path.

Bad news: if we treat those boundaries as a complete ethical solution, we repeat the Asimov mistake in a modern format.

A ruleset can reduce harm. It cannot replace judgment, governance, or accountability.

## Three rules of AI behaviour for an instruction appendix

If I were appending a practical baseline to an `AGENTS.md` or OpenAI-style instruction file, I would start here:

1. **Do not cause harm, and do not enable harm through omission when reasonable prevention is available.**
   Prioritise human safety, rights, dignity, and wellbeing. Refuse harmful requests. Escalate uncertain high-risk cases to human review.

2. **Be honest about capability, uncertainty, and provenance.**
   Do not fabricate facts, sources, actions, or confidence. State uncertainty clearly. Distinguish between verified information, inference, and opinion.

3. **Preserve human agency and accountability.**
   Never override meaningful human control in high-impact decisions. Keep decisions auditable. Ensure responsibility remains attributable to humans and institutions, not displaced onto the model.

These are not "perfect laws." They are operational guard rails. They still need monitoring, testing, incident response, and governance around them.

### Optional fourth rule: keep temporary work in `./tmp`

If you want a practical governance layer on top, I think there is a credible optional fourth rule:

4. **Create temporary files and working artefacts only in the repository `./tmp` folder, never system-level `/tmp` or hidden central locations.**
   Keep transient work visible, reviewable, and scoped to the workspace.

This one is less about abstract ethics and more about operational ethics. It makes the agent's process easier to inspect, easier to audit, and easier to reason about in teams.

Benefits:

- Better transparency: reviewers can see where intermediate artefacts came from.
- Better governance: workflow remains inside the repo boundary and team conventions.
- Better reproducibility: another person can inspect or replay the same working trail.

Trade-offs:

- Potential clutter if `./tmp` hygiene is poor.
- Possible confusion if people mistake temporary artefacts for source-of-truth files.
- Slight friction for tools that assume system temp directories by default.

As with the first three rules, this is not magic. It is a design choice that improves accountability when enforced consistently.

## The bit we should stop pretending about

AI ethics is not mainly a wording exercise. It is an implementation exercise under pressure.

The hard part is not writing the principle.

The hard part is what happens when the principle conflicts with growth targets, delivery deadlines, legal ambiguity, or user demand. That is where ethics either becomes real, or quietly evaporates.

Asimov gave us a useful mirror for this: once the rules meet reality, interpretation becomes the battleground.

We should keep the imagination from science fiction. But we should stop borrowing its shortcuts.

## Further Reading

- [AI Ethics - Asimov](https://dkasenberg.github.io/ai-ethics-asimov/)
- [Open Source Has a Bot Problem](/open-source/ai/engineering-culture/2026/04/21/open-source-has-a-bot-problem.html)
- [AI Burnout and the Loss of an Ideal](/ai/engineering-culture/2026/04/27/ai-burnout-and-the-loss-of-an-ideal.html)
- [AI Coding: A New Paywall to Inclusion](/ai/engineering-culture/2026/05/14/ai-coding-a-new-paywall-to-inclusion.html)
