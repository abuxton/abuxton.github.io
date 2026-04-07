---
layout: post
title: "Shadow Engineering: The Invisible Work That Holds Organisations Together"
date: 2026-04-07 17:34:54 +0000
categories: [engineering, community, shadow-engineering, enablement]
tags: [shadow-engineering, ghost-engineering, enablement, community, devops, engineering-culture, mentoring, knowledge-sharing]
---

This blog is called *Opinions of a Shadow Engineer* for a reason. But I have not written directly about what shadow engineering actually means — what it is, why it matters as a practice, how it sits at the heart of engineering enablement, and why organisations consistently fail to measure or recognise it.

Let me fix that.

## The Name Has a Backstory

The "Ghost Engineer" framing emerged from a [tweet by Yegor Bugayenko in November 2024](https://x.com/yegordb/status/1859290734257635439) that spread well beyond the usual corners of engineering social media. The claim: 95% of software engineers do virtually nothing. The evidence: if you look at their commit history, it is thin. The implication: thin commit history means low output, which means low value.

The [Reddit discussion that followed](https://www.reddit.com/r/theprimeagen/comments/1gzky88/95_of_software_engineers_do_virtually_nothing) was predictably divided. Some engineers recognised themselves in the criticism. Others pointed out, correctly, that the premise misunderstands what engineering actually is.

My response was to put "Ghost Engineer" in my GitHub profile — not as an apology, but as a direct challenge to the framing. Because the engineers being described as doing "virtually nothing" are often the ones doing the most important work in the organisation. I prefer the term shadow engineering, not because the work is hidden by design, but because it does not show up in the places most organisations look.

## What Shadow Engineering Is

Shadow engineering is the deliberate practice of doing the work that makes other engineers more capable, more confident, and more effective — as a primary contribution, not a side effect of seniority.

It is:

- **The conversation in Slack** that unblocks someone in ten minutes and prevents a three-day detour into the wrong solution
- **The code review** that does not just approve or reject, but explains *why*, and leaves the engineer who wrote the code with a clearer mental model than they had before
- **The runbook** that prevents the 3am incident because someone took the time to write down exactly what to do when the thing breaks
- **The pair programming session** where the point is not to write code faster, but for the other person to understand the problem deeply enough to solve it themselves next time
- **The documentation** nobody is asking for but everyone will need
- **The architecture discussion** that redirects a project before six months of work goes in the wrong direction
- **The mentoring relationship** that takes a capable junior and gives them the context to become a senior

None of these appear in commit history. Most do not appear in story points. All of them have measurable effects — on team velocity, on the number of incidents, on the time it takes new engineers to become effective, on the amount of rework that does not happen. But the link between the shadow engineering and the outcome is indirect, delayed, and invisible to any dashboard that measures individual output.

All good engineers are shadow engineers, no matter the industry. In a DevOps organisation, every engineer should be a shadow engineer at some point in their day.

## Shadow Engineering as a Practice of Engineering

There is a temptation to treat shadow engineering as soft — as the human side of engineering, distinct from the real technical work. That is backwards.

Shadow engineering is deeply technical. The code reviewer who can explain why a specific approach to connection pooling will cause problems under high load is not doing less technical work than the engineer who wrote the code. The architect who spots the impedance mismatch between two proposed systems before implementation begins is not doing less rigorous work than the people who would have built the mismatch. The person who writes the runbook that makes the on-call rotation survivable has to understand the system thoroughly enough to anticipate failure modes.

What shadow engineering requires, in addition to technical depth, is the ability to translate that depth — to make it available to other people, in the form they need, at the time they need it. That is a skill. It is learnable. And it compounds.

The [Scotty Principle](https://ipstenu.org/2011/the-scotty-principle/) — the engineering habit of building in headroom so that the unexpected does not become the catastrophic — is a good analogy here. An engineer who applies it protects the team from their own optimism. An engineer who *explains* it is shadow engineering explicitly: transferring a mental model that will make everyone around them more effective for the rest of their career.

The advance of AI and spec-driven development has made this more important, not less. AI can write code. It can generate test cases, summarise documentation, and draft runbooks. What it cannot do is carry institutional knowledge — the understanding of why a system was built the way it was, what was tried and rejected, what the constraints are that do not appear in any ticket. That knowledge lives in people, and it only survives if someone does the work of sharing it.

> All good engineers are Ghost Engineers. Ghost Engineering is the component that stats can't show, and A.I. will never be able to replace. Spend some time talking, showing, explaining, tutoring and continuing to learn. The stats don't show all; they are not the be-all and end-all.
>
> — [github.com/abuxton](https://github.com/abuxton/abuxton)

## Shadow Engineering as Enablement

Enablement is where shadow engineering overlaps with how organisations are structured and how capabilities are distributed across teams.

In the [DevOps community model](/devops/community/engineering-culture/2026/03/16/devops-is-not-a-job-title-it-is-a-community.html) — where capabilities, communication, and responsibilities form a Venn diagram with the community at the centre — enablement sits at the intersection of capabilities and communication. It is the people who have a capability making it possible for others to exercise that capability too. Not by doing it for them, but by sharing knowledge, writing it down, building tooling that makes it accessible, pairing until the other person can do it alone.

This is not a passive process. It requires the person with the capability to invest time and attention in the people around them rather than in their own output. That investment is invisible in most productivity metrics. It shows up eventually in team capability, reduced bus factor, faster onboarding, and the absence of incidents that did not happen because someone wrote the right runbook.

[DORA research](https://dora.dev) — the most rigorous empirical work on software delivery performance — consistently finds that the highest-performing engineering organisations are distinguished not by individual technical skill but by the conditions they create: psychological safety, clear communication, distributed ownership, rapid feedback loops. These are not individual output metrics. They are community conditions. And someone has to do the work of creating and maintaining them.

That work is shadow engineering.

There is also a practical automation angle worth naming here. The [do-nothing scripting pattern](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/) — writing scripts that walk through manual procedures step by step before automating any of them — is shadow engineering applied to process. It makes implicit knowledge explicit. It lowers the cost of the next person learning the procedure. It creates a foundation that can be automated incrementally, in a way that is transparent and reversible. The investment in writing it down is invisible in the short term and invaluable in the long run.

## Shadow Engineering Within an Organisation's Community

Organisations that understand shadow engineering have a different relationship with seniority. The career path is not just: more complex technical work, more autonomy. It is also: more deliberate investment in the capability of the people around you.

[Team Topologies](https://teamtopologies.com) articulates this through the idea of team cognitive load and the different modes of team interaction: collaboration, X-as-a-Service, and facilitating. Facilitation is the most shadow-engineering-intensive mode — the team that enables, teaches, and then steps back so that the capability is genuinely owned by the team they worked with, not just borrowed from them. The goal of facilitation is always to make itself unnecessary: to leave the other team more capable than it found them.

Etienne Wenger's work on [communities of practice](https://www.cambridge.org/gb/universitypress/subjects/psychology/educational-psychology/communities-practice-learning-meaning-and-identity) describes this dynamic at the organisational level. A community of practice is a group of people who share a concern, learn from shared experience, and develop their capabilities together over time. The most effective DevOps, platform, and engineering communities I have been part of work this way. They have senior engineers who treat the community's capability as their primary responsibility, not as a sideline to their individual technical output.

The challenge organisations face is that communities of practice are not organisational structures. You cannot create them by drawing them on a chart. You create them by having people who do the shadow engineering work — the teaching, the knowledge sharing, the documentation, the pair programming — consistently and deliberately, until the habits and the knowledge flows become self-sustaining.

This also means that the engineers who leave the most lasting impact on an organisation are often not the ones who built the most systems. They are the ones who built the most *engineers*. The ones who left behind not just code but the capacity in others to write better code, make better decisions, and pass those habits on in turn.

## What This Means for Measurement

Shadow engineering is hard to measure. That is not a reason to ignore it. It is a reason to think more carefully about what you are measuring and why.

Commit history, story points, PRs merged — these are measures of individual output. They are useful for some purposes and misleading for others. An engineer who closes fifty tickets a quarter while their knowledge stays siloed in their own head is less valuable to the organisation than one who closes thirty tickets and spends the rest of their time making the people around them demonstrably more capable.

The metrics that capture shadow engineering are indirect but real:

- **Team velocity over time**: does it increase as the shadow engineer's influence extends?
- **Time to productivity for new engineers**: does it fall?
- **Incident rate**: does the number of incidents that occur because nobody wrote the runbook go down?
- **Bus factor**: does the organisation become less dependent on specific individuals for critical knowledge?
- **Code quality across the team**: does it improve — not just in the shadow engineer's own work, but in the work of the people they review and mentor?

None of these are simple to attribute. All of them are real. The organisations that try to map individual value directly to individual output end up with engineers who optimise for visible output at the expense of exactly the shadow engineering work that would make the whole organisation more effective.

> "Anyone in tech looking at your commit history, taking a dive, and panicking shouldn't be in tech."
>
> — [github.com/abuxton](https://github.com/abuxton/abuxton)

## A Direct Note on AI

The shadow engineering argument has become sharper with the rise of AI-assisted development. If an AI can write the code, the question is not "can you write code?" — it is "can you make good decisions about what code to write, how to structure it, and how to build a team that uses AI tooling well?"

Those are shadow engineering questions. The answers live in people, in knowledge shared between people, in the conversations and code reviews and documentation that transmit understanding from the people who have it to the people who need it.

A senior engineer whose primary output is AI-generated code is an expensive individual contributor. A senior engineer whose primary output is a team that knows how to use AI well, understands its failure modes, and can build systems that remain maintainable under AI-assisted development — that is shadow engineering. The stats do not show all of it. They were never supposed to be the whole picture.

## Further Reading

- [Ghost Engineer tweet](https://x.com/yegordb/status/1859290734257635439) — The original provocation that launched the argument about what engineers actually do.
- [Reddit: "95% of software engineers do virtually nothing"](https://www.reddit.com/r/theprimeagen/comments/1gzky88/95_of_software_engineers_do_virtually_nothing) — The discussion that followed, which is more interesting than the tweet.
- [DORA Research](https://dora.dev) — The most rigorous empirical work on what actually drives software delivery performance. The factors that consistently matter are community and communication, not individual output.
- [Team Topologies](https://teamtopologies.com) — The best modern framework for thinking about how engineering teams should be structured around communication boundaries, cognitive load, and facilitation patterns.
- [Communities of Practice: Learning, Meaning, and Identity](https://www.cambridge.org/gb/universitypress/subjects/psychology/educational-psychology/communities-practice-learning-meaning-and-identity) — Etienne Wenger's foundational work on how communities learn and transmit knowledge over time.
- [The Scotty Principle](https://ipstenu.org/2011/the-scotty-principle/) — A classic articulation of the gap between how engineers estimate time and how managers interpret those estimates, and why that gap exists for good reasons.
- [Do-nothing scripting: the key to gradual automation](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/) — Dan Slimmon's post on making implicit procedural knowledge explicit, as a foundation for gradual automation.
- [People are not resources](https://www.jrothman.com/mpd/management/2014/08/people-are-not-resources/) — A long-held belief: the framing of engineers as units of output produces exactly the wrong incentives for shadow engineering to flourish.
