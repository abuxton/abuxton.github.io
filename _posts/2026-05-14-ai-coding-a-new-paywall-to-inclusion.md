---
layout: post
title: "AI Coding: A New Paywall to Inclusion"
date: 2026-05-14 18:00:00 +0000
categories: [ai, engineering-culture]
tags: [ai, llm, inclusion, local-llm, ollama, agents, paywall, accessibility, hardware, open-source]
---

I came across a post recently that I then promptly lost — the curse of reading across too many tabs. The thread I picked up on was this: coding was once genuinely inclusive. A cheap laptop, a browser, a text editor. Notepad, even. You could get started with software development at low cost and there were free tools for most of the journey. The author was asking whether the same is true today, with LLMs and agents baked into every serious development workflow. Whether access to the best AI coding tools has become a prerequisite for competing, and whether that prerequisite has a price tag that not everyone can meet.

It is a good question. And the answer, as usual, is more complicated than either camp wants it to be.

## The Original Promise

The accessible-coding origin story is real. In the late nineties and through the 2000s, the cost of getting started with software development genuinely was close to zero. A second-hand computer, a free operating system, a browser pointing at documentation and forums: that was enough. The tools that mattered were either free or freely copyable. The knowledge was distributed through mailing lists, IRC channels, and eventually Stack Overflow. You could get good at this without spending a meaningful amount of money.

That story mattered. It is part of why software development absorbed people from backgrounds that other professional fields did not. Not perfectly — the industry has always had diversity problems — but the economic barrier to entry was genuinely low. You could not be priced out of learning.

## The Current Landscape

Fast forward to 2026 and the surface picture looks similar. VS Code is still free. Git is still free. Python, Ruby, Go, Rust — all free. The tutorials have multiplied. GitHub provides free hosting. You can still start learning to code without spending money.

What has changed is the context. AI coding assistance has become a significant part of professional development workflows. GitHub Copilot is now an expected feature of developer environments at serious companies. Cursor, which builds on similar foundations, is in wide use. Agentic tools that can plan, write, test, and iterate on entire features are moving from experimental to routine. The developer who is not using some form of AI assistance is increasingly working at a disadvantage — not in terms of ability, but in terms of pace.

And most of the serious versions of these tools cost money.

## What You Pay For

The cloud-based AI coding tools fall into a fairly clear pricing tier.

GitHub Copilot runs at $10 per month for individuals. That gets you inline completion, a chat interface, and some agentic capabilities. The business tier is $19 per month. These are not ruinous amounts, but they are not free.

Cursor starts at $20 per month for the Pro plan. ChatGPT Plus and Claude Pro are both $20 per month. If you want frontier-model quality across your development workflow, you are looking at roughly $20 to $60 per month depending on what you stack together.

At the high end, Devin — the agentic coding system from Cognition — is priced for enterprise. The original pricing that circulated was in the region of $500 per month. That is not a hobbyist purchase.

These are not exploitative prices by the standards of professional software. A $10 or $20 monthly subscription is a fraction of what a development tools licence cost in previous decades. But they do represent a real cost, and they do create a threshold. For someone learning on a modest income, or for a developer in a context where $20 per month is a material expense, these tools are not automatically accessible.

## The Local Alternative Is Real

Here is the part of the conversation that gets less attention than it deserves: you do not have to use the cloud tools. There is a serious local AI ecosystem, and parts of it work well on modest hardware.

[Ollama](https://ollama.com) is the most important piece of this picture. It is a free, open-source tool that runs language models locally. You download it, you pull a model, and you run inference entirely on your own machine. No subscription. No API key. No data leaving your computer.

The question is which models you can run and on what hardware.

**Phi-3 Mini** (Microsoft, 3.8B parameters) requires about 2.3GB of disk space and can run meaningfully on a machine with 4GB of RAM. It is a genuinely capable small model for code completion and explanation tasks. If you have a cheap modern laptop with integrated graphics and 4GB of RAM, you can run this.

**Gemma 2 2B** (Google, 2B parameters) is similar in footprint — around 1.6GB. These very small models are not magic. They make errors that a frontier model would not make, and their context window is limited. But they are useful for a learning context, for explaining concepts, for suggesting structure.

**Mistral 7B** runs on 8GB of RAM with a 4.1GB file. This is a substantially more capable model — good code generation, better reasoning, more reliable output. A machine with 8GB of RAM can run it, though you will notice the generation speed compared to a cloud API.

**Llama 3.1 8B** (Meta) is roughly comparable in resource terms to Mistral 7B and is considered one of the better open models at that size. Again, 8GB of RAM will run it, though 16GB gives you more comfortable headroom.

**Llama 3.1 70B** is where hardware requirements become meaningful. You need roughly 40GB of RAM or the equivalent in GPU VRAM to run it. That is an Apple M2 or M3 Max with 64GB of unified memory (starting at £3,499), or a machine with a high-end NVIDIA GPU. This is not a hobbyist purchase. The 70B models are genuinely competitive with older frontier models. Running them locally requires hardware investment that prices out many people.

For coding workflows specifically, [Continue.dev](https://continue.dev) is a free VS Code extension that integrates with Ollama and local models. It provides the inline completion and chat interface that Copilot provides, but running against your local model. [Aider](https://aider.chat) is a free command-line tool that acts as a coding agent — you describe changes in natural language and it writes and applies the code. Both work with local models. Both are free.

## The Hardware Picture

This is where the paywall question gets its sharpest edges.

A basic laptop — say, a secondhand machine with 4GB of RAM — can run the smallest models adequately. Not fast, not impressively, but well enough to be useful for learning. If you are a student in a country where a £200 secondhand laptop represents real saving, you can still access local AI assistance. It will not be the same experience as a developer using Claude Pro on a MacBook Pro, but it is not nothing.

A mid-range machine with 8GB of RAM and integrated graphics — something you might buy new for £400 to £600 — can run 7B to 8B models. These are models that can materially help with coding: writing functions, explaining errors, suggesting test cases. This tier is genuinely useful for serious learning and hobby development.

The performance gap opens meaningfully above this. Frontier-class models — GPT-4 level, Claude Sonnet or Opus, Gemini 1.5 Pro — are not available locally at any price. They are cloud APIs. Running local models that approach their capability requires hardware investment of £1,500 or more, and even then you are not matching the frontier. The best accessible locally-run model is behind the best cloud-available model by a margin that professionals notice.

## What the Gap Actually Means

The original argument — that AI coding has become paywalled — is partially right, but more nuanced than it first appears.

You can still get started coding for free. The tools exist. Local models on modest hardware are genuinely useful, particularly for learning, for explanation, for smaller tasks. The floor has not been removed.

What has changed is the ceiling, and what has changed is the professional context. The tools that professional developers are using at competitive organisations are not the free local models. They are Copilot, Cursor, and the frontier cloud APIs. The developer who has access to those tools can iterate faster, get unstuck faster, produce more in less time. That speed difference is real and documented.

This creates a two-tier experience. Not a binary between access and no access, but a real gradient. The well-resourced developer — with a subscription budget and a machine capable of running local models well as backup — has access to the full capability stack. The less well-resourced developer has access to the lower end of that stack, which is useful but noticeably less powerful.

Whether you call that a paywall depends on your frame. It is not a locked door. But it is a toll road, and the quality of the road on the free path is meaningfully different from the road you pay for.

## The Structural Problem

There is also a less visible issue in the agent and infrastructure tier.

When we talk about AI coding assistance, we often mean completion and chat. But the more powerful shift is in agentic workflows: systems that can take a description of a feature, plan the implementation, write code across multiple files, run tests, and iterate on the result. These are the tools that [genuinely change the economics of producing software](/engineering/ai/shadow-engineering/2026/03/21/jensen-huang-wrong-500k-token-engineers.html).

The free and local versions of these agents exist — Aider, Open Interpreter, and similar tools. But they depend on the quality of the underlying model. Running an agent on Phi-3 Mini is a different experience from running one on GPT-4o. The planning capability, the context retention across long tasks, the ability to self-correct: these improve significantly with model scale. And the largest, most capable models are behind the cloud API paywall.

There is also a compute cost to agentic work that does not exist with simple completion. An agent that runs a full coding task makes dozens of API calls. On a free or low-tier plan, you hit rate limits. To use agentic tooling effectively, you generally need a paid plan with meaningful token allowances. That is a higher cost floor than passive completion.

## Where This Leaves Us

Coding is still more accessible than the alternatives. You can still learn, build, and get good at software development without a subscription budget. The free tier of AI assistance — local models on a reasonable machine, the free tiers of cloud tools — is genuinely useful and genuinely available.

But the original promise of the accessible coding path was that the tools available to a learner with a cheap laptop were meaningfully similar to the tools available to a professional. That promise is harder to sustain now. The delta between the free tier and the paid tier in AI coding is more significant than the delta was in the previous generation of development tools. VS Code on a cheap laptop and VS Code on an expensive one are the same tool. Ollama on a budget machine and Claude Pro on a high-spec machine are not the same tool, in a way that matters for the quality of what they help you produce.

The post I lost — the one I wish I had saved — was making a point about inclusion and the trajectory of that point is not comfortable. The lower bound has not been removed. But the upper bound has moved up considerably, and the distance between the two is growing.

Whether that becomes a genuine barrier to inclusion in the next generation of developers depends partly on the open-source ecosystem — on whether Ollama, Continue.dev, Aider, and the models they run on continue to close the gap with the frontier — and partly on whether organisations building the frontier tools find ways to keep meaningful access below the paywall.

It is worth watching. And it is worth naming.

## Further Reading

- [Ollama — run large language models locally](https://ollama.com)
- [Continue.dev — open-source AI coding assistant](https://continue.dev)
- [Aider — AI pair programming in your terminal](https://aider.chat)
- [Jensen Huang is Wrong About 500k Token Engineers](/engineering/ai/shadow-engineering/2026/03/21/jensen-huang-wrong-500k-token-engineers.html)
- [AI Burnout and the Loss of an Ideal](/ai/engineering-culture/2026/04/27/ai-burnout-and-the-loss-of-an-ideal.html)
