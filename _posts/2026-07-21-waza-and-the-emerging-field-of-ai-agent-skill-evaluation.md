---
layout: post
title: "Waza and the Emerging Field of AI Agent Skill Evaluation"
date: 2026-07-21 15:17:03 +0000
categories: [ai, development]
tags: [waza, evals, ai-agents, skills, promptfoo, deepeval, inspect-ai, openai-evals, evaluation]
---


 I thought it interesting to take a look at [Microsoft's Waza](https://microsoft.github.io/waza/) and compare it to whatever else exists for evaluating AI agents and skills. That request landed at a good moment. I have been quietly building [abuxton/Skills](https://github.com/abuxton/Skills) — a collection of `SKILL.md` files for coding agents, published via npm — and I have never had a satisfying answer to the question "how do I know these skills still work after I change the wording, swap models, or bump a dependency?" So this is as much me checking my own homework as it is a product review.

## What Is Waza?

[Waza](https://microsoft.github.io/waza/) ([GitHub](https://github.com/microsoft/waza)) is a Go CLI tool from Microsoft, built specifically for evaluating AI agent *skills* through structured benchmarks — not generic chatbot Q&A scoring, but the packaged, reusable-capability style of skill that Claude and Copilot both now support.

The shape of it:

- **YAML-defined evaluation specs.** Tasks, fixtures, and expected behavior are described in YAML, not code.
- **Fixture isolation.** Every task gets a fresh temp workspace with fixtures copied in. Originals are never mutated, which matters more than it sounds once you start running the same eval suite repeatedly.
- **11 built-in grader types**: Code (Python assertions), Regex, Keyword, File, Diff, JSON Schema, Prompt (LLM-as-judge), Behavior, Action Sequence, Skill Invocation, and Program execution validation.
- **Cross-model comparison.** Run the same suite against different models — `waza run eval.yaml --model gpt-4o`, then again with `--model claude-sonnet-4.6` — and diff the two result sets with `waza compare`.
- **A dashboard.** `waza serve` opens a local web UI at `localhost:3000` with runs, comparisons, trends, and live updates.
- **CI/CD native.** GitHub Actions integration ships out of the box, so evals can run on every pull request.

The pitch is "zero to your first benchmark in five minutes," and the design is unmistakably aimed at skill authors and platform teams who need to know *whether a skill still works*, not researchers trying to benchmark model intelligence in the abstract. It reads much more like a testing framework than an academic eval harness. That framing is exactly right, and it is the thing most of the general-purpose tools below don't quite give you.

## Why This Category Matters

The interesting shift is not "we need to grade LLM output" — that problem is old. It's that agents no longer just answer questions. They invoke skills, call tools, edit files, run commands, and leave a filesystem or a repo in a different state than they found it. Scoring a string is not the same job as validating a *sequence of actions*.

That's precisely the gap my own Skills repo has never closed. Each `SKILL.md` is really a small procedural contract — do-nothing scripting, gitattributes management, npm publishing, gist handling — and I have been checking that those contracts still hold the hard way: by running the skill again and eyeballing the result. Waza's Behavior, Action Sequence, and Skill Invocation graders are a direct, purpose-built answer to that exact problem. Seeing it laid out as a dedicated grader type made me realize how much I've been doing this manually.

## Comparable Tools

| Tool | Focus | Language/Interface | Notable strength |
| --- | --- | --- | --- |
| **[Waza](https://github.com/microsoft/waza)** | Agent *skill* evaluation | Go CLI, YAML specs | Purpose-built for skill/tool-invocation grading; dashboard + CI baked in |
| **[Promptfoo](https://github.com/promptfoo/promptfoo)** | LLM eval & red-teaming | Node CLI/library, YAML/JS config | Mature red-teaming and prompt-regression tooling; now backed by OpenAI |
| **[DeepEval](https://github.com/confident-ai/deepeval)** | LLM app evaluation framework | Python, pytest-style | Rich metric library (RAG, hallucination, bias) with a "test framework for LLMs" feel |
| **[Inspect AI](https://inspect.aisi.org.uk/)** | Frontier model & agent evaluation | Python framework | Built by the UK AI Security Institute; 200+ pre-built benchmarks, strong for safety/agentic evals |
| **[OpenAI Evals](https://github.com/openai/evals)** | Model evaluation registry | Python/YAML | The original open eval registry; now largely superseded by OpenAI's dashboard-based Evals product |
| **[Ragas](https://github.com/explodinggradients/ragas)** | RAG pipeline evaluation | Python | Focused specifically on retrieval-augmented generation quality metrics |
| **[LangSmith](https://www.langchain.com/langsmith) / [Braintrust](https://www.braintrust.dev/)** | Eval + observability platforms | Hosted SaaS + SDKs | Production tracing tied directly to eval datasets; good for teams already on LangChain or wanting a hosted loop |

A few of these are worth a closer look, because "comparable" is doing a lot of work in that table and I don't want to flatten real differences into a single row.

**Promptfoo** is what most people reach for first, and for good reason — it's fast to adopt, has a large open-source community, and covers both quality evals and adversarial red-teaming from one CLI. It isn't opinionated about "skills" specifically; it treats prompts and apps more generically. But it's battle-tested, and being folded into OpenAI hasn't slowed it down.

**DeepEval** leans hard into a pytest-shaped developer experience — you write eval cases the way you'd write unit tests — and ships one of the broader metric libraries out of the box, especially around RAG accuracy and hallucination detection. If your team already thinks in `pytest` and wants evals sitting in the same CI step as everything else, this is the natural fit.

**Inspect AI** is the heavyweight. Built by the UK AI Security Institute with Meridian Labs, it ships 200+ implemented benchmarks and a full solver/scorer/tool/agent abstraction model. It's more framework than CLI, with a steeper learning curve than anything else on this list, but it's the closest thing to a standard in AI safety evaluation circles, and it shows in the depth of what it can express.

**OpenAI Evals** was the original open registry — it's the project that normalized "evals as YAML plus code" years before Waza existed. OpenAI has since moved most day-to-day eval work into its hosted dashboard product, and the open-source repo has gone comparatively quiet as a result. Worth knowing about historically, less worth adopting fresh today.

## Where Waza Fits

If the problem in front of you is "I ship Claude- or Copilot-style skills and need to know they still work across models and prompt changes," Waza's fixture isolation, skill-invocation grader, and PR-integrated dashboard make it a very direct fit — arguably the most skill-shaped tool on this list. If the problem is broader LLM app quality — RAG accuracy, red-teaming, general agent safety benchmarking — Promptfoo, DeepEval, Ragas, or Inspect AI are more mature, more general-purpose choices with bigger ecosystems behind them.

My take: Waza doesn't need to "beat" any of these. It's carving out the skill-evaluation niche that the others treat as an afterthought. For my own Skills repo, that's exactly the missing piece — a way to define, per skill, what "still works" actually means, and let CI tell me when it stops being true instead of finding out the hard way mid-session.

## Further Reading

- [Waza](https://microsoft.github.io/waza/) — Microsoft's CLI for evaluating AI agent skills
- [Waza on GitHub](https://github.com/microsoft/waza)
- [Promptfoo](https://github.com/promptfoo/promptfoo) — LLM evals and red-teaming
- [DeepEval](https://github.com/confident-ai/deepeval) — pytest-style LLM evaluation framework
- [Inspect AI](https://inspect.aisi.org.uk/) — UK AI Security Institute's frontier evaluation framework
- [OpenAI Evals](https://github.com/openai/evals) — the original open eval registry
- [Ragas](https://github.com/explodinggradients/ragas) — RAG pipeline evaluation
- [abuxton/Skills](https://github.com/abuxton/Skills) — my own agent skills repository, the reason I went looking for this in the first place
- [Building Agent Skills: Do-Nothing Scripting and Gradual Automation](/development/automation/agents/2026/04/05/building-agent-skills-do-nothing-scripting.html) — background on that repo
