---
layout: post
title: "Local Models for Coding: The Detox Experience"
date: 2026-08-04 14:06:00 +0000
categories: [ai, development]
tags: [local-models, qwen, gemma, ollama, agents, coding-assistants, hardware, mlx, gguf]
---

Birgitta Böckeler at Thoughtworks spent four weeks running AI coding models locally on Apple Silicon and wrote up what she learned in two detailed memos: [factors affecting viability](https://martinfowler.com/articles/exploring-gen-ai/local-models-for-coding-factors.html) and [practical experiences](https://martinfowler.com/articles/exploring-gen-ai/local-models-for-coding-experiences.html). The short version is that local models for agentic coding are not plug-and-play, fall well short of cloud-based alternatives, but can be useful for specific tasks when properly configured — and the experience of working with weaker models forces better engineering discipline.

That last point is the one that stuck with me.

## What Makes Local Models Viable

Böckeler tested on M3 Max (48GB RAM) and M5 Pro (64GB RAM) hardware, running models between 15-25GB in size. The viability question breaks down into twelve interacting factors:

| Factor | Key Constraint |
| --- | --- |
| **RAM** | Model weights must fit in available memory; 48GB comfortable for ~30B parameter models |
| **Processing Power** | More cores = faster token generation, but degrades as conversation lengthens |
| **Memory Bandwidth** | Bottleneck for token generation; both test machines had ~300 GB/s |
| **Model Parameters** | More parameters = better quality but larger size; tested 30B ±5B on 48GB machine |
| **Reasoning** | Chain-of-thought helps complex tasks but slows responses; sometimes better turned OFF |
| **Tool Calling** | Essential for agentic coding; common failure point with malformed calls |
| **Format (GGUF vs MLX)** | GGUF standard for llama.cpp, largest library; MLX Apple-specific, potentially faster |
| **Quantization** | Q4/Q6/Q8 compression; all tested models used Q4 quantization |
| **Architecture (MoE)** | Mixture of Experts activates subset of weights; significantly less RAM needed |
| **Context Window** | Minimum 32K needed, 64K recommended; consumes RAM through KV cache |
| **Runtime** | Used LM Studio for UX; handles model loading, config, API integration |
| **Harness** | Different frameworks inject varying overhead; used OpenCode and Pi |

The standout finding: **Qwen 3.6 35B MoE** (22GB, Q4 quantization) offered the best balance of capability, speed, and RAM footprint.

The baffling finding: the same model with identical settings produced better code — not just faster, but better quality — on the 64GB machine than the 48GB machine. That optimization mystery remains unexplained.

## The Evaluation Funnel

Böckeler's testing approach was methodical:

1. Does it fit in RAM?
2. Does it run at reasonable speed?
3. Can it handle tool calling?
4. Does it build functionally correct code?
5. Can it handle continued conversation?
6. Can it handle larger/complex tasks?
7. Is code quality acceptable?

Most models failed somewhere in that funnel. Tool calling was the most common breaking point — models frequently produced malformed tool invocations, though they could usually self-correct and recover.

The practical tasks tested included:
- Modifying existing bar charts (sorting, cumulative percentages)
- Creating new visualizations from access log data
- Bash and Python scripts
- Website content updates
- Small codebase changes

**Successes:** Small, well-defined tasks often worked. Bash and Python scripts generally more successful than JavaScript. Adding content to existing structures worked well.

**Failures:** Inconsistent results between runs. Memory-intensive operations. Complex logic and cumulative calculations. Code search and multi-file edits problematic.

## What This Means For Custom Agents

The interesting part for me is not whether local models match cloud models — they do not, and Böckeler is clear about that — but what happens when you combine local models with custom agent skills.

I have been building [abuxton/Skills](https://github.com/abuxton/Skills), a collection of `SKILL.md` files for coding agents. Each skill is a small procedural contract: do-nothing scripting, gitattributes management, npm publishing, gist handling. The question I have never had a satisfying answer to is "how do I know these skills still work after I change the wording, swap models, or bump a dependency?"

Local models change that calculation in two ways:

### 1. Skills become testable iteration loops

With cloud models, every test run costs money and latency. With local models, you can iterate on skill definitions rapidly without worrying about API costs or rate limits. That makes it practical to:

- Test multiple phrasings of the same instruction
- Validate that a skill works across different model sizes
- Catch regressions when updating skill dependencies
- Build evaluation harnesses (like [Waza](https://microsoft.github.io/waza/)) that run on every commit

The trade-off is quality. Local models will produce worse results than GPT-4 or Claude Sonnet. But for skill development, "does this instruction pattern work at all?" is often more valuable than "is this output perfect?"

### 2. The detox effect is real

Böckeler describes working with weaker models as a "detox" experience:

> Forces more careful code review  
> Provides better signals about what helps/doesn't  
> Encourages slower, more thoughtful work  
> Reduces tendency to blindly accept AI outputs

That resonates. When the model is weaker, you cannot rely on it to paper over vague instructions. You have to be precise. You have to review carefully. You have to think about what you are asking for before you ask.

That discipline carries over. Once you have built skills that work reliably with a 30B parameter model running locally, those same skills will work better with cloud models — because you have already done the hard work of making the instructions clear, testable, and robust.

## Practical Setup

Böckeler's recommended default configuration:

- **Model:** Qwen 3.6 35B MoE (4-bit quantization)
- **Reasoning:** Disabled (surprisingly often better)
- **Context window:** Maximum available
- **Harness:** OpenCode or Pi
- **Runtime:** LM Studio or similar
- **Hardware:** Close other high-RAM applications during use

That is not a trivial setup. It requires:
- Apple Silicon with 48GB+ RAM (or equivalent)
- Understanding of quantization formats
- Willingness to experiment with different harnesses
- Patience with inconsistent results

But for skill development and testing, it is a viable workflow.

## What Local Models Are Not

Local models for agentic coding are **not**:

- Plug-and-play replacements for cloud models
- Reliable enough for production use without heavy review
- Consistent across runs
- Good at complex multi-file refactoring
- Fast enough to feel instant

They are also not free. The hardware cost is real. An M3 Max with 48GB RAM is not cheap, and 64GB configurations cost more.

## What Local Models Are

Local models for agentic coding **are**:

- Useful for small, well-defined tasks
- Good for rapid iteration on skill definitions
- Effective forcing functions for better prompts
- Viable for testing and evaluation workflows
- Surprisingly capable for single-file modifications

And most importantly: they change the economics of experimentation. When every test run is local, you can afford to fail more often. That matters for skill development.

## The Real Comparison

The comparison is not "local models vs cloud models" in the abstract. It is "what can I do with local models that I cannot do with cloud models?"

The answer:

- Iterate on skills without API costs
- Test evaluation frameworks locally
- Build muscle memory for precise instructions
- Maintain better review discipline
- Experiment freely without worrying about rate limits

Those are not small things. For someone building agent skills, those are exactly the things that matter.

## A Colleague's Experience

Böckeler mentions that Jigar Jani at Thoughtworks successfully uses local models for real-world Python and React development by:

- Continuously enhancing the harness with skills
- Maintaining rigorous code review practices
- Treating the model as a junior pair programmer, not an oracle

That tracks with my own experience. The value is not in the model replacing judgment. The value is in the model reducing friction for well-defined, repeatable tasks while you maintain the discipline to review everything.

## Final Thought

Local models for coding are not ready for "plug and play." They are messy, inconsistent, and frustrating if you expect them to match cloud model quality.

But for skill development, testing, and building better engineering discipline, they are surprisingly useful.

The detox effect is real. Working with weaker models forces you to be clearer, more precise, and more thoughtful about what you are asking for. That discipline carries over to everything else.

For me, that is enough reason to keep experimenting.

## Further Reading

- [Viability of Local Models for Coding: Factors](https://martinfowler.com/articles/exploring-gen-ai/local-models-for-coding-factors.html) — Birgitta Böckeler's detailed analysis of technical factors
- [Viability of Local Models for Coding: Experiences](https://martinfowler.com/articles/exploring-gen-ai/local-models-for-coding-experiences.html) — Practical experiences and evaluation results
- [Waza](https://microsoft.github.io/waza/) — Microsoft's CLI for evaluating AI agent skills
- [abuxton/Skills](https://github.com/abuxton/Skills) — My agent skills repository
- [Building Agent Skills: Do-Nothing Scripting](/development/automation/agents/2026/04/05/building-agent-skills-do-nothing-scripting.html) — Background on skill development approach
- [Waza and the Emerging Field of AI Agent Skill Evaluation](/ai/development/2026/07/21/waza-and-the-emerging-field-of-ai-agent-skill-evaluation.html) — My earlier post on evaluation frameworks
