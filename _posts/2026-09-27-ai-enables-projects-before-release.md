---
layout: post
title: "AI Enables Projects Before They Are Ready to Be Released"
date: 2026-09-27 09:00:00 +0100
categories: [development, ai]
tags: [ai-agents, software-engineering, open-source, decision-making, developer-tools]
---

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)

An idea used to need a fair amount of ceremony before it became software.
Someone needed enough uninterrupted time to make a start. A team needed enough
shared context to agree on a shape. The first working prototype often arrived
only after the idea had survived a fairly effective filter: the cost of getting
from "this might be interesting" to a repository that did something.

Agentic development lowers that threshold. By that I mean a workflow in which
an AI can take bounded actions: explore a repository, draft code and
documentation, run checks, and report the result back for a human to judge. It
does not remove the need for engineering. It changes when the engineering
becomes visible.

One person can now take an architectural question and give it a real shape
without first assembling a team or clearing a week of calendar time. They can
ask an agent to sketch the service boundary, generate a local environment,
write a first test suite, document an API, and then make the prototype answer
back. That is a genuinely useful expansion of what is possible.

It also creates a question I do not think we can answer from the public web:
how many serious experiments now live in private repositories?

## The hidden portfolio

Public GitHub gives us a distorted view of software creation. It shows projects
that have been released, work deliberately shared in the open, and the
occasional experiment that somebody was comfortable making visible. It cannot
show the projects that are still internal, abandoned, useful only to one team,
or simply not ready for the obligations that come with an audience.

I would not put a number on that hidden portfolio. There is no defensible
public dataset for "AI-enabled private repositories", and a count of public
repositories, stars, or generated commits would not fill the gap. The useful
claim is smaller: when implementation becomes cheaper, more ideas can become
working private projects. Some will remain sketches. Some will become valuable
internal tools. Some may eventually become products or open-source projects.
Many will not, and that is not necessarily a failure.

The evidence on speed is already more complicated than the headline suggests.
A [Microsoft Research analysis of three company field
experiments](https://www.microsoft.com/en-us/research/publication/the-effects-of-generative-ai-on-high-skilled-work-evidence-from-three-field-experiments-with-software-developers/)
estimated a 26% increase in completed tasks after developers gained access to
an AI coding assistant, while also warning that the individual experiments were
noisy. In a different setting, [METR's 2025 study of experienced open-source
contributors](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
found longer completion times with the then-current tools; its
[later update](https://metr.org/blog/2026-02-24-uplift-update/) cautioned that
the result had already aged badly and that newer measurement was not reliable
enough to state a current effect.

That is a useful corrective. "AI makes software faster" is not a law of
nature. The effect depends on the task, the developer, the codebase, the tools,
and the quality of the question being asked. But a faster first pass, even in a
limited set of tasks, can still change what a person is willing to explore.

## Pheromone: public source is not a public promise

[Pheromone](https://github.com/abuxton/pheromone) is now public. It began on
18 February 2026 as an exploration of what might happen if AI-capable processes
could communicate with and manage distributed systems. Its published
documentation describes a Go-based distributed digital-twin platform, with a
one-to-many model across operating-system, workload, and management layers.

The public repository makes the project's shape inspectable: its architecture
decision records, local development environments, contributor guide, security
policy, and source are available for others to evaluate. It is MIT-licensed,
but its own README calls it early-stage. There are no GitHub releases or tags
from which to infer a stable version or a release cadence.

That distinction matters because a public repository is not the same thing as a
general-purpose, production-ready service. Pheromone's published security
policy describes work that remains to be done on transport security,
network-level authentication, and sandboxing. Until then, it instructs
operators to use network-isolated deployments and trusted built-in skills. That
is a useful public threat-model boundary, not a promise that every deployment
is safe.

The repository does show some stewardship signals. Its contributor guide
requires tests, linting, and architecture-decision records for material
changes, and it directs vulnerability reports to GitHub's private reporting
channel rather than public issues. Those are concrete processes. They do not,
on their own, establish who will support users, what response capacity exists,
or a wider governance model.

Agent assistance made the project's expansion possible. It helped turn a
question into supporting tooling, tests, documentation, local environments, and
operational scaffolding that would have been difficult to sustain from the
original idea alone. Public release makes that work available for scrutiny. It
does not turn a functioning project into a promise to strangers.

A release still needs different answers:

1. Who is the user, specifically?
2. What is the smallest promise I am prepared to make and keep?
3. What threat model is acceptable for that promise?
4. Who will support users, respond to issues, and maintain the project?
5. Is the governance mature enough for others to trust the direction?
6. Should this become a product at all?

None of those questions is answered by a passing test suite, a clean
architecture diagram, or another hundred generated files. They are product,
security, and stewardship decisions. They are also decisions that get harder
to make when it is cheap to keep building.

## Decision atrophy is a risk worth naming

I use *decision atrophy* here to mean the loss of practice in making the
judgement calls that automation can defer. It is not a diagnosis, and it is not
a claim that using an agent makes someone less capable. It is a workflow risk.

When the next implementation step is always available, it can become easier to
add another capability than to narrow the scope. It can feel more productive to
request another experiment than to decide that the audience is too unclear, the
support burden is too high, or the project should stop. Agents do not create
that temptation on their own, but they make continuation unusually frictionless.

There is relevant evidence outside software engineering. A peer-reviewed
[study of AI-assisted decision-making](https://doi.org/10.1145/3449287) found
that participants could over-rely on incorrect AI recommendations, and that
interventions requiring people to consider alternatives reduced that
over-reliance. It does not prove that coding agents cause bad product
decisions. It does support the more modest point: plausible recommendations
and explanations are not substitutes for independent judgement.

For a project, independent judgement looks practical rather than mystical:
write down the intended user, put a boundary around the first release, invite a
critical review, and decide in advance what evidence would make the project
worth publishing. These steps introduce useful friction. They force a builder
to confront the cost that did not appear in the prototype.

## What public projects can and cannot show us

[OpenClaw](https://github.com/openclaw/openclaw) is an interesting public
counterpoint. Its repository describes an open-source assistant that runs on a
user's computer and connects to existing chat channels through a local gateway,
clients, tools, skills, plugins, and selectable model providers. That is the
project's description, not an independent assessment of its security or
quality.

There are clearer signs that the project is being actively maintained. Its
[contribution guide](https://github.com/openclaw/openclaw/blob/main/CONTRIBUTING.md)
sets review, build, check, and test expectations, including for AI-assisted
submissions. Its [v2026.7.33 release](https://github.com/openclaw/openclaw/releases/tag/v2026.7.33)
was published on 18 September 2026 and records 126 merged pull requests in its
covered range. The public npm registry recorded
[13,759,846 downloads](https://api.npmjs.org/downloads/point/last-month/openclaw)
in the preceding month when I checked on 18 September.

That last number is a distribution signal, not a user count. It may include
CI, upgrades, mirrors, and repeat downloads. Likewise, stars and forks are
evidence of interest, not proof that a project is good, safe, or sustainably
used. What OpenClaw does demonstrate is the work that becomes visible once a
project has crossed the release boundary: release records, public maintenance
rules, contributor expectations, and an audience that can evaluate the work.

The project's creator, [Peter Steinberger, describes](https://steipete.me/posts/just-talk-to-it)
an agentic workflow in which agents write nearly all of his code and several
agents work in parallel. That is useful first-person evidence about one
creator's practice. It is not evidence that every line of OpenClaw was
AI-generated, nor should it be treated as a quality certificate.

There is a related, more limited public example in
[Anthropic's account of how its teams use Claude Code](https://claude.com/blog/how-anthropic-teams-use-claude-code).
It describes internal autonomous development loops in which the tool writes
code, runs tests, and iterates before human review, including an example of
Claude Code building Vim key bindings for itself. The
[Claude Code changelog](https://code.claude.com/docs/en/changelog) shows
continuing releases. Again, this is vendor evidence of an AI-assisted workflow
and maintenance, not an independent audit of quality or a measure of adoption.

The caveats are not a footnote. They are the point. Visibility can teach us
about public maintenance, but visibility and popularity cannot tell us whether
a project should exist, whether it is safe for a particular user, or whether
the people behind it have made good decisions.

## A release is a promise, not an upload

The most useful guardrails are straightforward:

- Name the audience in one sentence.
- State a small public promise and explicitly list what is out of scope.
- Do a threat-model review that fits the intended deployment.
- Decide what maintenance commitment, support channel, and documentation a
  user can reasonably expect.
- Ask someone outside the build loop to challenge the assumptions.
- Make a deliberate choice to publish, keep the work private, or stop.

The final option deserves more respect than it usually receives. A private
repository can be a successful place to learn, investigate, or solve an
internal problem. Public release is not the only measure of value.

Agentic development gives more people the capacity to find out whether an idea
has technical shape. That is exciting. The next responsibility is to recognise
that a functioning repository is evidence of possibility, not yet a promise to
users. Publishing is the moment we make that promise. It should still require a
human decision.

## Further reading

- [The effects of generative AI on high-skilled work](https://www.microsoft.com/en-us/research/publication/the-effects-of-generative-ai-on-high-skilled-work-evidence-from-three-field-experiments-with-software-developers/) — Microsoft Research field experiments on coding-assistant access
- [Early-2025 AI experienced open-source developer study](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) and [METR's update](https://metr.org/blog/2026-02-24-uplift-update/) — evidence and limitations from a different setting
- [Effects of explanations and cognitive forcing functions on overreliance on AI decision support systems](https://doi.org/10.1145/3449287) — a peer-reviewed study of over-reliance
- [Pheromone](https://github.com/abuxton/pheromone), its [contributor guide](https://github.com/abuxton/pheromone/blob/main/CONTRIBUTING.md), and its [security policy](https://github.com/abuxton/pheromone/blob/main/SECURITY.md) — primary sources for its public scope and stated operating boundaries
- [OpenClaw](https://github.com/openclaw/openclaw) and its [contribution guide](https://github.com/openclaw/openclaw/blob/main/CONTRIBUTING.md) — primary project sources
