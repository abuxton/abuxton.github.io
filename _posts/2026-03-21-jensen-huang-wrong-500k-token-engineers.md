---
layout: post
title: "Jensen Huang is Wrong About 500k Token Engineers"
date: 2026-03-21 15:07:28 +0000
categories: [engineering, ai, shadow-engineering]
tags: [ai, llm, tokens, jensen-huang, nvidia, shadow-engineering, engineering-culture, individual-contributor]
---

Jensen Huang recently posted a [YouTube Short](https://youtube.com/shorts/Hg0Vus39I60?si=vv6e7scq6GW0LEAr) that has stuck in my head — and not in a good way. He talks about engineers and AI token spend, and makes the case that high token spend is the metric of a productive, AI-native engineer. His framing puts 500k tokens as something to aspire to. I think he's wrong. Worse, I think it's wrong in a way that is going to damage how organisations think about the engineers they have and the engineers they hire.

Let me explain why.

## The Spend-to-Cost Curve

When you're investing in any kind of tooling or capability, there's a relationship between what you spend and the value you get back. At low spend, you're usually getting linear returns — spend a bit more, get a bit more. But at high spend, the expectation should shift: you're not paying for linear returns, you're paying for leverage. Exponential uplift. Force multiplication.

500k tokens is not cheap. At current pricing, depending on the model, that's a non-trivial engineering cost per engineer per month. If your argument for that spend is "they write more code faster" — that is a terrible return. You haven't achieved leverage. You've paid a premium for a faster typist.

An engineer at 500k token spend should be **below the cost curve**, not on it. Below the curve means you're extracting disproportionate value relative to spend. If they're just writing code faster, you're on the curve at best — more likely above it, paying over the odds for something you could get cheaper with a junior engineer and a lower-tier model.

The metric Jensen is proposing — token spend as a productivity signal — mistakes activity for leverage.

## What 500k-Token Engineers Should Actually Be Doing

If you have an engineer who is comfortable spending 500k tokens, who understands how to prompt effectively, who can navigate model behaviours, who knows what to hand off and what to hold — that person is not a coding machine. That person is someone you should be using to lead.

Specifically: to lead development practice and knowledge sharing. That knowledge is the rarest resource in any engineering organisation. Not the ability to write more functions — the ability to teach others how to use AI well, to set standards, to architect systems that work with AI tooling, to document the patterns that make the whole team faster.

If your 500k-token engineer is spending those tokens writing code, you have made a mistake. Not because the code is bad. But because you have used a force-multiplier as an individual contributor.

## Shadow Engineering

This blog is called *Opinions of a Shadow Engineer* for a reason. The [Ghost Engineer note](https://x.com/yegordb/status/1859290734257635439) that I keep on my GitHub profile captures something real: the most important work in engineering organisations is frequently invisible in commit counts and story points. It is the explaining, the pair programming, the code review that actually teaches rather than just approves, the runbook that prevents the 3am incident, the Slack thread that upskills three people at once.

Shadow engineering is the practice of deliberately doing that work — not as a side effect of being senior, but as the primary contribution.

At 500k tokens, an engineer should be doing shadow engineering: using AI tooling to amplify their ability to teach, guide, and multiply the capability of the people around them. They should be the person who helps others understand what to prompt, when to push back on an AI output, how to structure a codebase so it stays maintainable under AI-assisted development.

If instead they are writing code — even impressive code, even a lot of code — they are an expensive individual contributor. That's not a compliment.

## Where Jensen's Framing Goes Wrong

The problem with measuring engineers by token spend is that it implicitly defines the value of an engineer as their direct output. Code shipped, functions written, PRs merged. That model was already incomplete before AI. With AI, it actively gets in the way of good engineering practice.

The engineers you want at 500k token spend are the ones who can answer:

- How do we integrate AI tooling into our development lifecycle without creating a mess that nobody can maintain?
- What are the patterns that make AI-assisted code reviewable, testable, and understandable to a team of twelve people in two years' time?
- How do we teach the rest of the team to use these tools effectively rather than building a two-tier workforce of AI-natives and everyone else?

Those questions are not answered by writing more code faster. They're answered by people doing the slow, invisible work of making an engineering organisation smarter.

## A Better Signal

If you want a metric for whether your 500k-token engineers are earning their spend, don't count their tokens. Count their multiplier effect. Ask:

- How many other engineers are doing AI-assisted work differently because of this person?
- How much rework or tech debt has been avoided because of the architectural guidance they provided?
- What documentation, standards, or tooling exist now that wouldn't exist without them?

These are hard to measure. Token spend is easy to measure. That doesn't make token spend the right thing to measure.

Jensen Huang builds the hardware that makes this all possible, and NVIDIA's work is genuinely impressive. But he's making the same mistake organisations have made with every previous productivity tool: assuming that more usage means more value, and that direct output is the right thing to optimise for.

At 500k tokens, you're not trying to optimise a developer's coding speed. You're trying to change how an entire engineering organisation works. That's a Shadow Engineering problem. And it won't be solved by more code.

