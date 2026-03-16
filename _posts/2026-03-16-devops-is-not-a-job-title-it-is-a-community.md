---
layout: post
title: "DevOps is not a job title, it is a community"
date: 2026-03-16 15:08:49 +0000
categories: [devops, community, engineering-culture]
tags: [devops, roadmap, community, capabilities, communication, responsibilities]
---

[roadmap.sh](https://roadmap.sh) is one of those resources that has quietly become genuinely useful. Community-driven, open source, and surprisingly honest about the complexity of modern engineering roles. The [DevOps roadmap](https://roadmap.sh/devops) in particular is worth bookmarking — not because it tells you what to learn, but because it shows you how much there is to know, and in roughly what order it starts to matter.

I want to talk about it. But first I need to take issue with a question.

## The FAQ Problem

Down in the frequently asked questions section of the DevOps roadmap, there is this question: [**"What skills are required to become a DevOps Engineer?"**](https://roadmap.sh/devops#:~:text=What%20skills%20are%20required%20to%20become%20a%20DevOps%20Engineer)

It is a reasonable question. It is also the wrong question. Not because the answer is bad — the answer is actually pretty solid, covering Linux, scripting, CI/CD, containers, cloud, networking, IaC, monitoring, and version control. But the framing contains an assumption that I think does a lot of damage to how people understand DevOps: the assumption that DevOps is a thing you *become*.

DevOps is not a job title. It is a community.

That might sound like a semantic argument. It is not. It changes what you measure, what you value, and crucially, what you build.

## What a Community Looks Like

Communities are measurable. They have properties, they produce outcomes, and they can be healthy or dysfunctional in ways that job titles cannot. A community has:

- **Capabilities** — the things its members can do, individually and together
- **Communication** — how information, feedback, and knowledge flow between members
- **Responsibilities** — who owns what, who is accountable, and how that accountability is distributed

These three things — Capabilities, Communication, and Responsibilities — are the axes against which any DevOps community, any DevOps tool, and any DevOps process can be evaluated. And critically, they overlap. The overlap is where the interesting stuff happens.

## The Venn Diagram

<div style="display:flex; justify-content:center; margin: 2em 0;">
<svg viewBox="0 0 500 460" width="500" height="460" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="DevOps Community Venn Diagram: three overlapping circles representing Capabilities, Communication, and Responsibilities, with DevOps Community at the centre">
  <!-- Capabilities circle (top-left) -->
  <circle cx="195" cy="175" r="140" fill="#4A90D9" fill-opacity="0.35" stroke="#4A90D9" stroke-width="2"/>
  <!-- Communication circle (top-right) -->
  <circle cx="305" cy="175" r="140" fill="#7ED321" fill-opacity="0.35" stroke="#7ED321" stroke-width="2"/>
  <!-- Responsibilities circle (bottom-centre) -->
  <circle cx="250" cy="270" r="140" fill="#F5A623" fill-opacity="0.35" stroke="#F5A623" stroke-width="2"/>

  <!-- Circle Labels -->
  <text x="115" y="105" text-anchor="middle" font-size="15" font-weight="bold" fill="#1a3a5c">Capabilities</text>
  <text x="385" y="105" text-anchor="middle" font-size="15" font-weight="bold" fill="#2d5a0a">Communication</text>
  <text x="250" y="430" text-anchor="middle" font-size="15" font-weight="bold" fill="#7a4a00">Responsibilities</text>

  <!-- Intersection: Capabilities + Communication (top centre) -->
  <text x="250" y="145" text-anchor="middle" font-size="11" fill="#333">Enablement</text>
  <text x="250" y="160" text-anchor="middle" font-size="10" fill="#555">(sharing knowledge,</text>
  <text x="250" y="173" text-anchor="middle" font-size="10" fill="#555">teaching, tooling docs)</text>

  <!-- Intersection: Capabilities + Responsibilities (bottom-left) -->
  <text x="178" y="295" text-anchor="middle" font-size="11" fill="#333">Practice</text>
  <text x="178" y="308" text-anchor="middle" font-size="10" fill="#555">(IaC, automation,</text>
  <text x="178" y="321" text-anchor="middle" font-size="10" fill="#555">runbooks, SLOs)</text>

  <!-- Intersection: Communication + Responsibilities (bottom-right) -->
  <text x="322" y="295" text-anchor="middle" font-size="11" fill="#333">Culture</text>
  <text x="322" y="308" text-anchor="middle" font-size="10" fill="#555">(blameless retros,</text>
  <text x="322" y="321" text-anchor="middle" font-size="10" fill="#555">feedback loops, trust)</text>

  <!-- Centre: All three -->
  <text x="250" y="228" text-anchor="middle" font-size="13" font-weight="bold" fill="#111">DevOps</text>
  <text x="250" y="244" text-anchor="middle" font-size="13" font-weight="bold" fill="#111">Community</text>
</svg>
</div>

Each circle on its own is incomplete:

- **Capabilities without Communication** gives you technically excellent people who don't share knowledge and build silos.
- **Communication without Responsibilities** gives you great conversations that produce no ownership and drift into learned helplessness.
- **Responsibilities without Capabilities** gives you accountability theatre — people who own things they cannot actually fix.

The intersections are where coherence emerges:

- **Enablement** — where Capabilities and Communication meet. This is the people who write good runbooks, who pair on incidents, who actually document the thing they just built. Good DevOps communities produce enablement naturally.
- **Practice** — where Capabilities and Responsibilities meet. IaC is here. SLOs are here. The shift from "ops does it" to "the team owns the pipeline" is here.
- **Culture** — where Communication and Responsibilities meet. Blameless postmortems live here. So does psychological safety. So does the decision to stop a deploy when something looks wrong.

The centre — where all three overlap — is the DevOps community itself. Not a team. Not a job description. A community of practice that owns its capabilities, communicates freely about failure and learning, and takes responsibility for the full lifecycle of the thing it builds.

## What This Means for the Roadmap

Go back to [roadmap.sh/devops](https://roadmap.sh/devops) and look at the roadmap with this framing. Most of the content sits in **Capabilities**: Linux, scripting, containers, CI/CD, cloud providers, observability tooling. It is a solid map of what a capable practitioner needs to be able to do.

What is less explicit — but not absent — is the **Communication** layer: on-call culture, incident communication, documentation standards, feedback loops between development and operations teams. And the **Responsibilities** layer: who owns the pipeline, who is on call, who decides when a service is production-ready.

The roadmap is not wrong. It is just partial. It documents one-third of the diagram very well, and gestures at the rest.

That is not a criticism of roadmap.sh. It is honest about its scope. A visual roadmap of technical skills is genuinely useful. But if you use it as the complete answer to "how do I do DevOps", you will end up with capable individual contributors who are not part of a DevOps community.

## Measuring Against the Three Axes

The useful thing about this model is that it is *measurable*. Not with precision, but with enough signal to tell you where things are going wrong.

For a **DevOps community**:
- Capabilities: Can the team deploy independently? Do they understand their observability stack?
- Communication: Do incidents produce shared learning? Do postmortems get read?
- Responsibilities: Is on-call burden distributed fairly? Does ownership of services actually mean something?

For a **DevOps tool** (say, a new CI/CD platform):
- Capabilities: Does it increase what the team can do, or just add another dashboard?
- Communication: Does it make build and deploy state visible to everyone who needs it?
- Responsibilities: Does it make ownership clearer, or does it introduce shared ownership that nobody actually owns?

For a **DevOps process** (say, a deployment pipeline):
- Capabilities: Does the pipeline enable the team to move faster with confidence?
- Communication: Does it surface failures clearly and quickly?
- Responsibilities: Is it clear who fixes a broken pipeline, and can they actually fix it?

The answers sit on spectrums, not binaries. But asking the questions forces clarity that "are we doing DevOps properly?" never does.

## The Hiring Problem

The reason this matters practically is hiring. "DevOps Engineer" as a job title has been around long enough to have calcified into something specific in most organisations: a person who manages CI/CD pipelines and cloud infrastructure so that developers don't have to think about it. That is not DevOps. That is operations with a rebrand.

The actual DevOps insight — from the original [Agile infrastructure](https://www.slideshare.net/slideshow/agile-infrastructure-and-operations-how-infra-get-its-mojo-back-agile-2008/161226) work, from [The Phoenix Project](https://itrevolution.com/product/the-phoenix-project/), from the DORA research — is that the separation between development and operations is the problem. DevOps is the practice of removing that separation. You cannot remove it by creating a new team that sits between developers and operations.

A "DevOps Engineer" who is the only person in the organisation who knows how the pipeline works is not doing DevOps. They are doing ops. Probably good ops. But the community they are part of has not adopted DevOps practices — it has hired someone to perform DevOps practices on its behalf, which is the opposite of the point.

## So What Do You Actually Need?

roadmap.sh's answer to "what skills are required?" is still useful. You need to understand Linux. You need to be able to script. You need to understand networking, containers, CI/CD, cloud infrastructure, and observability. The [DevOps roadmap](https://roadmap.sh/devops) covers that terrain well, and it has the benefit of being community-maintained and honestly scoped.

But if you want to *be part of a DevOps community*, you also need:
- To be willing to make knowledge available to the people around you (Communication)
- To own something fully — including the parts that break at 2am (Responsibilities)
- To improve your capabilities continuously, not just to pass a skills checklist (Capabilities as growth, not static inventory)

The Venn diagram does not care what your job title is. It asks: what can your community do, how well does it communicate, and how clearly does responsibility sit? The teams I have seen that get this right do not have "DevOps Engineers". They have engineers who have built a DevOps community together.

## Further Reading

- [roadmap.sh/devops](https://roadmap.sh/devops) — The roadmap itself. Start here for the technical skills layer.
- [DORA Research](https://dora.dev) — The most rigorous empirical work on what actually makes software delivery perform well.
- [The Phoenix Project](https://itrevolution.com/product/the-phoenix-project/) — Still the clearest narrative explanation of why the dev/ops split is the problem.
- [Team Topologies](https://teamtopologies.com) — The best modern framework for thinking about how teams should be structured around communication and responsibility boundaries.

