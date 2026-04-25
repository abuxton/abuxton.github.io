---
layout: post
title: "Agentic Observability: Watching the Machines That Work for You"
date: 2026-04-25 08:28:12 +0000
categories: [ai, engineering, observability, agents]
tags: [ai-agents, observability, copilot, claude, openai, codex, langfuse, phoenix, gridwatch, llmops, metrics, dashboards]
---

There is a particular kind of irony in the current state of AI-assisted development. We have built AI agents that work on our behalf — writing code, reviewing pull requests, researching problems, running pipelines — and yet we have almost no systematic way to watch what they are doing. We can see the output. We rarely see the process.

That gap is closing. The discipline of agentic observability is emerging to fill it, and the tools available range from built-in platform features to rich open-source dashboards and enterprise-grade platforms. This post takes you from the first thing most developers discover — "what has my AI actually been doing?" — to the ecosystem of projects that answer that question at scale.

## Why Observability Matters for AI Agents

In traditional software engineering, observability means being able to understand the internal state of a system from its external outputs. Logs, traces, and metrics — the three pillars of observability — give you the visibility to understand not just that something went wrong, but where, when, and why.

AI agents add a new set of questions:

- How many tokens did this session consume, and how close to the context window limit did it run?
- Which prompts produced good results and which produced noise?
- How much has this agent cost me this month?
- Is the agent actually using the tools and context I have given it?
- When the agent compacted the context, what was lost?
- Across all my sessions, am I getting more effective at prompting, or am I repeating the same mistakes?

These are not abstract concerns. Token usage maps directly to billing. Context window pressure shapes the quality of responses. Prompt patterns determine whether you are using the agent's capabilities well or poorly. Without visibility into these things, you are flying blind.

The agents themselves are doing a job. Observability is how you manage that job — and improve it.

## What the Platforms Give You by Default

The reasonable question to ask first is: what do GitHub Copilot, Anthropic Claude, OpenAI, and similar platforms already offer? The answer is: more than most users realise, but less than power users need.

### GitHub Copilot

GitHub Copilot has the most developed built-in usage visibility of the major AI coding assistants, partly because it has had the longest time to mature and partly because usage-based billing creates a strong incentive for transparency.

**In your IDE**, Copilot displays usage information directly. In VS Code, clicking the Copilot icon in the status bar shows your current plan, your progress towards any usage limits, and when your allowance resets. Visual Studio, JetBrains IDEs, Xcode, and Eclipse all surface similar quota information through their respective Copilot UI elements. As of April 2026, Pro, Pro+, and student plans have tighter session and weekly limits, and the IDE surfaces warnings when you approach them.

**In GitHub.com billing settings**, navigating to `github.com/settings/billing` gives you a metered usage view. Clicking through to **Premium request analytics** provides a more detailed breakdown: usage over time, by feature (Copilot Chat, Copilot coding agent, Spark), filterable by timeframe, with chart export. Enterprise owners and billing managers can view usage by individual user; organisation owners can download usage reports.

**Via the API**, Copilot usage data is accessible programmatically through the GitHub API, which is useful for teams building their own reporting and cost allocation tooling.

What Copilot does not expose natively: session-level detail, prompt quality metrics, token utilisation curves over the course of a session, MCP server activity, or agent-level breakdowns. For those, you need something else.

### Anthropic Claude

Claude Code (Anthropic's CLI agent) and the Claude API both provide usage reporting, though the default visibility is more limited and leans towards API consumers rather than interactive users.

The **Anthropic console** at `console.anthropic.com` provides usage dashboards for API subscribers: token counts by model, spend over time, and usage by API key. These are useful for teams building applications on top of Claude but less directly relevant to an individual developer using Claude Code interactively.

Claude Code itself does not currently have a built-in session dashboard comparable to Copilot's IDE integration. Usage tracking is available at the API level. There is no equivalent of Copilot's IDE status bar quota display for Claude Code out of the box.

Claude does expose usage metadata in its API responses — `input_tokens`, `output_tokens`, and `cache_read_input_tokens` / `cache_creation_input_tokens` for prompt caching scenarios — so applications built on Claude can observe usage in real time. But the agent itself does not aggregate this into an accessible session view by default.

### OpenAI and Codex

OpenAI's platform includes a **Usage dashboard** at `platform.openai.com/usage` showing API request volume, token consumption by model, and estimated spend, with daily granularity and model-level breakdown. The dashboard is accessible to anyone with an OpenAI API account.

OpenAI Codex — the cloud-based coding agent — follows a similar pattern: billing and usage are visible through the platform dashboard but there is no session-level introspection or per-task observability built into the agent interface itself.

The OpenAI API returns token usage in response objects (`usage.prompt_tokens`, `usage.completion_tokens`, `usage.total_tokens`), and recent API versions include reasoning token breakdowns for o-series models. Again, this is API-level visibility for application builders, not native observability for interactive agent users.

### The Pattern

The pattern is consistent across all three platforms: **billing-level visibility exists**, but it operates at the account or API key level, not at the session, prompt, or task level. You can see that you spent 50,000 tokens on Tuesday. You cannot easily see which sessions those came from, whether any individual session was poorly prompted, or how your context window utilisation has changed over time.

That is the gap the community has moved to fill.

## From Files to Dashboards: What Lives Locally

Before reaching for an external platform, it is worth understanding what data already exists on your machine.

GitHub Copilot CLI writes session state to `~/.copilot/session-state/`. Each session gets its own directory containing:

- An `events.jsonl` file with every user message and agent event
- Checkpoint files for context compaction events
- Metadata about the session type, start time, and status

This is comprehensive local data. It is structured, it is timestamped, and it records everything. The challenge is that it was never designed to be human-browsable at scale. Opening individual JSONL files and reading through events manually is fine for debugging a single session. It tells you almost nothing about patterns across fifty sessions over a month.

The data is there. What was missing was a tool to make it useful.

## GridWatch: A Local Dashboard for Copilot CLI

[GridWatch](https://github.com/faesel/gridwatch), created by Faesel Ahmed, is the most feature-complete answer currently available to the question: "how do I actually understand what my Copilot CLI sessions have been doing?"

It is an Electron desktop application — built with Node.js, React, and TypeScript — that reads directly from `~/.copilot/session-state/` and presents the data as a retro Tron-themed dashboard. The aesthetic is distinctive: neon cyan and electric blue on near-black, with JetBrains Mono typography. But the substance is what matters.

**What GridWatch gives you:**

- **Sessions overview**: all your Copilot CLI sessions browsable in a paginated list, with live status, token utilisation, and the last prompt from each session. Sessions are automatically categorised as Research, Review, or Coding based on the agents used.
- **Token usage graphs**: line charts showing peak context window utilisation over time, with 1D / 1W / 1M / ALL filters. This is the closest thing to understanding your actual token pressure over a period.
- **Compaction tracking**: when Copilot compacts the conversation context, GridWatch surfaces the event — showing trigger utilisation, how many messages were replaced, tokens saved, and the compacted summary. You can read the full checkpoint markdown inline.
- **Prompt history**: every user message from a session's `events.jsonl` is readable directly in the UI, without needing to open JSONL files manually.
- **Activity heatmap**: a GitHub-style contribution grid showing session activity across 52 weeks. A useful proxy for understanding your working patterns.
- **MCP server dashboard**: all installed Model Context Protocol servers (local and remote), with the ability to enable/disable them, browse their tool catalogues, see environment variables (with secret masking), and view connection times.
- **LSP server dashboard**: Language Server Protocol servers from `~/.copilot/lsp-config.json`, with enable/disable controls.
- **Agents panel**: built-in Copilot agents (Research, Code Review, Coding) alongside your custom agents, with session counts, usage statistics, and linked session history.
- **Skills management**: browse, create, edit, and manage your Copilot CLI skills, with tagging, import/export, and toggle controls.
- **AI Insights**: an optional feature that uses OpenAI to analyse prompt quality and suggest improvements.

GridWatch requires Node.js 18+, npm 9+, and runs on macOS and Windows. Pre-built installers are available from the [releases page](https://github.com/faesel/gridwatch/releases). On macOS, the app is not code-signed, so you will need to run `xattr -cr /Applications/GridWatch.app` after installation to bypass Gatekeeper.

I have [forked GridWatch](https://github.com/abuxton/gridwatch) primarily to track the project and explore usage. If you are a Copilot CLI user and you want to understand your sessions properly, GridWatch is currently the most practical way to do it without building something yourself.

The fact that a community tool needs to exist to surface this data says something about the current state of native observability from GitHub. The data is there. The platform does not yet expose it well.

## The Broader Ecosystem: LLM and Agent Observability at Scale

GridWatch solves a specific problem: local visibility into Copilot CLI sessions. But the field of agentic observability extends well beyond that, particularly for teams building applications on top of LLMs, or running AI agents in production environments.

Several strong open-source projects have emerged here, each with a different emphasis.

### [Langfuse](https://github.com/langfuse/langfuse)

Langfuse is one of the most widely adopted open-source LLM engineering platforms. It focuses on the full lifecycle: observability, evaluation, prompt management, and datasets. Instrumentation is via SDKs (Python and TypeScript) or OpenTelemetry, and it integrates with OpenAI SDK, LangChain, LiteLLM, and many others.

The core value proposition is tracing: every LLM call in your application gets recorded with inputs, outputs, latency, token counts, and cost estimates. Traces are linked into sessions and can be tagged, annotated, and scored. This makes it possible to move from "something went wrong in this session" to "this prompt pattern consistently produces poor outputs" — the kind of insight that actually improves agent behaviour over time.

Langfuse is self-hostable via Docker. Arize AI also offers a managed cloud instance for teams that do not want to operate the infrastructure themselves.

### [Arize Phoenix](https://github.com/Arize-ai/phoenix)

Phoenix from Arize AI positions itself as an AI observability platform for experimentation, evaluation, and troubleshooting. The observability layer is built on OpenTelemetry, which means instrumentation integrates with existing telemetry infrastructure rather than requiring a separate stack.

Phoenix supports tracing for a broad range of frameworks: OpenAI Agents SDK, Claude Agent SDK, LangGraph, CrewAI, LlamaIndex, DSPy, Vercel AI SDK, and more. Beyond raw tracing, Phoenix includes evaluation tooling (using LLMs to score responses), dataset management for versioned test sets, and a prompt management and playground interface.

It runs locally, in Docker, or in the cloud via `app.phoenix.arize.com`. The OpenInference project (also from Arize) provides the underlying instrumentation libraries.

### [Helicone](https://github.com/Helicone/helicone)

Helicone takes a different approach: it operates as a proxy between your application and the LLM provider's API. You change one line of code (your API base URL), and Helicone intercepts all traffic, logging requests and responses with full fidelity.

This frictionless instrumentation is Helicone's key differentiator. There is no SDK to integrate, no trace context to propagate. Everything that goes through the proxy gets recorded. The dashboard surfaces latency, token usage, cost, error rates, and user-level breakdowns. Helicone is particularly popular for teams that want comprehensive logging with minimal integration effort.

### [Laminar](https://github.com/lmnr-ai/lmnr)

Laminar describes itself as an observability platform purpose-built for AI agents, with a particular focus on the multi-step, multi-tool nature of agentic workflows. Beyond tracing, it includes evaluation tooling, datasets, and online evaluation of production traces.

The emphasis on agents rather than simple LLM calls is worth noting. Most LLM observability tools were originally designed for request-response workflows and have adapted to agents. Laminar was designed with agentic workflows as the primary use case.

### [OpenLit](https://github.com/openlit/openlit)

OpenLit is a broader platform that spans LLM observability, GPU monitoring, guardrails, prompt management, and evaluation. It is built on OpenTelemetry and integrates with more than 50 LLM providers, vector databases, and agent frameworks. The GPU monitoring angle is distinctive — relevant for teams running their own inference infrastructure rather than consuming API services.

### [Opik by Comet](https://github.com/comet-ml/opik)

Opik from Comet ML focuses on debugging, evaluation, and monitoring for LLM applications, RAG systems, and agentic workflows. The comprehensive tracing integrates with an evaluation framework and production monitoring dashboard. Teams already using Comet ML for traditional ML experiment tracking will find Opik's integration with that existing stack useful.

### [TraceRoot](https://github.com/traceroot-ai/traceroot)

TraceRoot is a newer entrant, positioning itself as an observability and self-healing layer for AI agents. The self-healing angle — automated detection and response to agent failures — goes beyond passive monitoring into active intervention, which is an interesting direction for the space.

## The Common Thread

What all of these projects share is the recognition that LLM API calls and agent sessions are not meaningfully observable through traditional application monitoring. The data is different in kind: token budgets, context windows, prompt quality, reasoning traces, multi-step tool use. The signals that matter for debugging and improvement are specific to how LLMs work.

The pattern in the ecosystem also reflects a broader shift in how we think about AI in production. A year ago, most teams were treating LLM calls as black boxes: you send a prompt, you get a response, you move on. The emergence of detailed tracing, evaluation, and analytics tooling reflects the maturation of that approach. The black box is being opened.

GridWatch does this at the individual developer level, surfacing session data that Copilot CLI already produces but buries in JSONL files. Langfuse, Phoenix, and Helicone do it at the application and team level, providing the infrastructure for systematic improvement across thousands of interactions. They are solving the same fundamental problem at different scales.

## What Is Still Missing

The native observability gap at the developer tools level is worth naming explicitly. GridWatch exists because GitHub does not yet expose session-level Copilot data in a useful form. Claude Code has no session dashboard. OpenAI Codex has no task-level introspection. The platform-level billing analytics tell you what you spent; they do not tell you whether you are using the tools well.

This will change. The commercial incentive is clear: teams that understand their AI usage optimise it, and optimised usage is stickier. GitHub has begun moving in this direction with IDE quota displays and premium request analytics. But the depth of insight that GridWatch delivers from locally available data suggests how much more is possible — and how much the platforms have yet to build.

For individual developers, the practical position today is:

- **Know what your platform exposes**: Copilot's IDE integration and billing analytics, OpenAI's usage dashboard, Anthropic's console. These are free, built-in, and worth understanding.
- **Use GridWatch if you are a Copilot CLI user**: it turns data you already have into actionable insight without requiring external infrastructure.
- **Reach for Langfuse, Phoenix, or Helicone if you are building on LLM APIs**: the observability infrastructure will pay for itself in debugging time and cost reduction.

## Further Reading and Projects

- [GridWatch](https://github.com/faesel/gridwatch) — Local Copilot CLI session dashboard by Faesel Ahmed
- [abuxton/gridwatch](https://github.com/abuxton/gridwatch) — Fork tracking usage and exploration
- [Langfuse](https://github.com/langfuse/langfuse) — Open-source LLM engineering platform: tracing, evals, prompt management
- [Arize Phoenix](https://github.com/Arize-ai/phoenix) — AI observability and evaluation built on OpenTelemetry
- [Helicone](https://github.com/Helicone/helicone) — LLM proxy-based observability with one-line integration
- [Laminar](https://github.com/lmnr-ai/lmnr) — Observability platform purpose-built for AI agents
- [OpenLit](https://github.com/openlit/openlit) — OpenTelemetry-native LLM observability, GPU monitoring, and prompt management
- [Opik by Comet ML](https://github.com/comet-ml/opik) — Debug, evaluate, and monitor LLM apps and agentic workflows
- [TraceRoot](https://github.com/traceroot-ai/traceroot) — Observability and self-healing for AI agents
- [GitHub Copilot Usage Docs](https://docs.github.com/en/copilot/managing-copilot/monitoring-usage-and-entitlements/monitoring-your-copilot-usage-and-entitlements) — Official documentation for Copilot usage monitoring

