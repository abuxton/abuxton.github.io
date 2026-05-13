---
layout: post
title: "curl, AI Analyzers, and High-Quality Chaos"
date: 2026-05-13 14:03:09 +0000
categories: [security, ai]
tags: [curl, ai, security, open-source, bug-bounty, hackerone, code-analysis, maintainers]
---

Daniel Stenberg has published a run of posts recently that are worth reading together rather than one at a time: [curl security moves again](https://daniel.haxx.se/blog/2026/02/25/curl-security-moves-again/), [High-Quality Chaos](https://daniel.haxx.se/blog/2026/04/22/high-quality-chaos/), and [Mythos finds a curl vulnerability](https://daniel.haxx.se/blog/2026/05/11/mythos-finds-a-curl-vulnerability/).

Taken together, they tell a much more interesting story than the usual AI discourse. Not "AI changes everything" in the abstract, and not "AI is all hype" either. Something more useful than that: AI tooling has genuinely changed security work, but it has also changed the operational burden around that work, and mature projects are having to redesign their response.

That is what I find so interesting about curl's position. Daniel is not doing boosterism here, but he is also not pretending the tooling does not matter. I agree with him on that.

## The Mythos post is interesting for the right reason

The most recent post, on Mythos finding a curl vulnerability, is not really interesting because a frontier model found *a* bug. At this point that is almost the least surprising part of the story.

What is interesting is the calibration.

A much-hyped model arrives with a lot of surrounding noise, scans one of the most scrutinised C codebases on the planet, and reports five confirmed vulnerabilities. The curl security team reviews them, trims that to one real vulnerability, and carries on. That is a very healthy response.

It is neither panic nor denial. It is exactly what you would want from a serious project: use the tool, review the claims, keep what is real, discard what is not, and improve the codebase anyway.

The other part of Daniel's post that stood out to me was this summary of how AI analyzers differ:

> - They can spot when the comment says something about the code and then conclude that the code does not work as the comment says.
> - It can check code for platforms and configurations we otherwise cannot run analyzers for.
> - It “knows” details about 3rd party libraries and their APIs so it can detect abuse or bad assumptions.
> - It “knows” details about protocols curl implements and can question details in the code that seem to violate or contradict protocol specifications.
> - They are typically good at summarizing and explaining the flaw, something which can be rather tedious and difficult with old style analyzers.
> - They can often generate and offer a patch for its found issue, even if the patch usually is not a 100% fix.

That feels right to me.

This is where the real shift is. Not mystical machine intuition. Not the end of software engineering. Just a very material expansion in what can be checked quickly, what can be compared against comments and specifications, and how easily findings can be explained to humans. That last point matters more than it gets credit for. A tool that helps a maintainer understand *why* something might be wrong is often more useful than one that simply emits a warning.

## High-quality chaos is a very good phrase

The April post, [High-Quality Chaos](https://daniel.haxx.se/blog/2026/04/22/high-quality-chaos/), is where the wider picture comes into focus.

The striking thing there is not just that report volume is up. It is that the nature of the incoming reports changed. The slop problem dropped away, but the rate of high-quality reports increased. Confirmed vulnerabilities went up. Bug reports that were not security issues but were still real defects also went up.

That is a profound change in the environment maintainers operate in.

AI has lowered the cost of reading a large codebase, cross-checking assumptions, following variant patterns, and packaging the result into something that looks like a professional report. That is good news if you care about finding bugs before attackers do. It is less comfortable news if you are the person who has to triage all of that work, decide what is real, and then get the fixes out without burning out your maintainers.

"High-quality chaos" is a very good name for that state. The chaos is not gone. It has become more useful.

## The platform move matters as much as the model move

That is also why [curl security moves again](https://daniel.haxx.se/blog/2026/02/25/curl-security-moves-again/) matters in this sequence.

The interesting point there, at least from where I sit, is that AI tooling did not just change bug discovery. It changed the requirements of the process around bug discovery. curl tried moving security reporting onto GitHub after ending the old bug bounty arrangement, then concluded that this was a mistake and moved back to HackerOne.

That is not a side note. It is part of the same story.

When AI-assisted research increases both the volume and the quality of incoming reports, workflow design suddenly matters much more. Intake, deduplication, private handling, reporter interaction, triage discipline, all of the supposedly boring operational bits become central again. If the reporting channel is wrong, the quality of the models does not save you.

That is one of the more useful correctives to AI hype. Better tooling does not remove the need for good systems. In some ways it increases it.

## AI tooling and bug bounties now shape each other

I also think the relationship between AI tooling and bug bounties is becoming clearer.

Bug bounties create incentives. AI lowers the cost of searching for issues and writing them up. Put those two things together and you do not just get more reports. You get a changed population of reports and reporters.

Some of that produces junk, as plenty of projects discovered the hard way.

Some of it produces exactly what Daniel is describing now: more frequent, more polished, sometimes duplicated, often AI-assisted submissions that are still materially valuable.

That means maintainers need to get sharper about the distinction between *more output* and *more usable output*. It also means the projects that adapt their process fastest will probably benefit most from the new tooling. The model helps find the issue, but the project still needs a way to receive, validate, coordinate, fix, and disclose it.

In other words, the AI story here is not just about better detection. It is about a new pressure on maintainer operations.

## The part I agree with most

The part of Daniel's argument I agree with most strongly is the least sensational one: modern AI analyzers are genuinely useful, and pretending otherwise is foolish. But the useful way to understand them is as force multipliers for existing security work, not as magical replacements for expert review.

The curl team still had to assess the findings. They still had to separate vulnerability from bug, bug from false positive, signal from marketing. They still had to adjust their intake process when the old route stopped working. That human response is the real story.

What AI has changed is the pace, the breadth, and the economics of finding problems. What it has *not* changed is the need for judgement.

That is why these posts are so worth reading together. They show both sides at once: the gain in capability, and the need to redesign process around it.

That feels a lot more real, and a lot more useful, than either hype or dismissal.

## Further Reading

- [curl security moves again](https://daniel.haxx.se/blog/2026/02/25/curl-security-moves-again/)
- [High-Quality Chaos](https://daniel.haxx.se/blog/2026/04/22/high-quality-chaos/)
- [Mythos finds a curl vulnerability](https://daniel.haxx.se/blog/2026/05/11/mythos-finds-a-curl-vulnerability/)
- [Open Source Has a Bot Problem](https://blog.abcdevelopment.co.uk/open-source/ai/engineering-culture/2026/04/21/open-source-has-a-bot-problem.html)
