---
layout: post
title: "Coding Is Planning"
date: 2026-07-08 07:51:45 +0000
categories: [ai, development]
tags: [ai, agents, workflows, coding, planning, spec-driven-development, cognitive-debt]
---

I have just read Lars Faye's post, [Agentic Coding is a Trap](https://larsfaye.com/articles/agentic-coding-is-a-trap), and it is worth your time.

Not because I agree with every implication in the strongest possible form, but because it names a tension that a lot of people are currently trying very hard not to name. We are being sold a version of "AI-native" development where the ideal outcome is that the machine writes, the human supervises, and the main skill of software engineering becomes orchestration. Plan well, prompt clearly, review quickly, ship faster.

That is an attractive story. It is also incomplete to the point of being dangerous.

The strongest part of Lars's post for me is not the general warning about cognitive debt, though I think that warning is real. It is the section titled **Coding === Planning**. That is the bit that hit home.

## Some Of Us Think In Code

There is a strain of argument around agentic development and spec driven development that treats coding as a low-value transcription step. First the important people think. Then they write the spec. Then the machine, or the junior, or the invisible implementation layer turns that spec into code.

That model has always been a little suspect, and AI has made the weakness more obvious rather than less.

For some of us, coding is not what happens after the thinking. Coding is how the thinking happens.

I do not mean that in a romantic "true programmers yearn for the terminal" way. I mean something more practical. A lot of design decisions do not become clear until you start touching the actual shapes involved. You write the type. You sketch the function. You move a file. You realise two concepts that looked separate in prose are actually one thing in code, or worse, one thing in prose and three things in practice. You discover the awkward edge case not by imagining it in a paragraph but by trying to represent it.

That matters because prose is permissive. Specs can glide over ambiguity in a way code simply cannot. A paragraph can sound complete while hiding three unanswered questions about error handling, data ownership, security boundaries, naming, or the shape of state. The minute you start writing code, those questions stop being theoretical.

So when Lars pushes on the idea that "coding === planning", I think he is pointing at something real: implementation is not merely downstream of design. Very often it is the act that reveals the design.

## Where This Meets Spec Driven Development

This is also where I think the article is most useful as a corrective to the more breathless versions of spec driven development.

To be clear, I do not think spec driven development is nonsense. I use specs. I like plans. I have spent quite a lot of time building workflows that start with exactly that. The problem is not the presence of a spec. The problem is the claim, sometimes spoken and sometimes implied, that once the spec exists the important thinking is done.

A good spec gives you intent, boundaries, and a shared reference point. It helps stop people wandering off in entirely different directions. It can make agentic work more reliable because it reduces ambiguity before the model starts filling the gaps with confidence it has not earned.

But a spec is not a substitute for the contact between a developer and the code.

At its best, spec driven development is a way to improve implementation. At its worst, it becomes a fantasy that implementation can be safely abstracted away into a probabilistic blur so long as the preamble was well written enough.

That is where the whole thing starts to wobble.

The harder or more novel the work is, the less I trust a giant up-front spec to fully capture what needs to happen. Not because specs are bad, but because discovery is part of engineering. Sometimes the shortest path to clarity is not another page of prose. It is ten lines of exploratory code, a rough type definition, a failed test, or a half-built structure that shows you where the idea breaks.

If you remove that from the workflow entirely, you are not just going faster. You are changing how understanding is formed.

## The Supervision Problem Is Real

Lars is also right to dwell on the contradiction in the current sales pitch. The person supervising generated code is assumed to be highly capable, deeply attentive, and able to spot subtle problems in architecture, correctness, maintainability, and security. Fine. But those are exactly the capabilities that weaken if your day-to-day relationship with code becomes distant enough.

You do not keep your edge in anything by only reviewing large volumes of machine output.

This is the part of the discourse that often feels dishonest. The same people telling us that the future is orchestration also quietly assume that the orchestrator has retained all the hard-won understanding of a hands-on engineer. They want the benefits of abstraction without the loss that abstraction often carries.

The problem, as the article lays out well, is that this loss no longer looks hypothetical. The concern is not simply that junior developers might learn less. It is that everyone starts drifting away from the friction that built the judgment in the first place.

## My Workflow Has Ended Up In Roughly The Same Place

What interested me most, though, was Lars's description of his daily workflow, because I have arrived at something very similar from the opposite direction.

I am not anti-agentic work. Quite the opposite. I use agentic workflows constantly now. They have made this blog easier to run. They have made writing more accessible to me. They help me research, structure, scaffold, summarise, and get from rough idea to workable draft much faster than I could on my own when the friction is high.

But the pattern that has emerged for me is not "the agent codes while I supervise from a tasteful distance."

It is much closer to this:

- I use agents to help me think before and around the coding.
- I use them to generate plans, challenge assumptions, summarise sources, and do the repetitive bits.
- I use them to scaffold pieces of implementation when the shape is already clear enough that I can judge the output properly.
- I keep the generated chunks small enough that I can actually review them with my brain switched on.
- I stay close enough to the code that my own understanding of the system keeps increasing rather than slowly evaporating.

That is not me rejecting AI. That is me demoting it to a role that I think is sustainable.

And yes, that means sometimes I am still writing a lot of the code myself. Sometimes most of it. Sometimes nearly all of it. Other times I am using generated snippets, suggested refactors, or agent-produced drafts as accelerants. The percentage is not the point. The relationship is the point.

I do not want to become a manager of code I no longer fully know how to produce.

## Planning Still Matters, But It Is Not The Whole Job

There is an unhelpful false choice in a lot of these conversations:

- either you are a serious modern engineer doing high-level planning while the models implement
- or you are a nostalgic craft romantic insisting everything be typed by hand forever

That is nonsense.

The useful middle ground is obvious once you stop performing the future for LinkedIn.

Planning matters. Specs matter. Structured prompts matter. Breaking work into well-bounded tasks matters. Clear acceptance criteria matter. I am more effective with agents when I do all of that. In that sense, the spec driven people are not wrong.

But they are wrong if they think those things eliminate the need for direct engagement with code.

The more I use agents well, the more I find myself wanting tighter loops, not looser ones. Smaller tasks. More explicit boundaries. Less "build me the whole thing" and more "help me reason about this piece". Less slot machine. More collaboration. Less distance.

That is because the output is better, but it is also because *I* stay better.

## The Rule I Keep Coming Back To

If I had to reduce my own position to one rule, it would be this: **never outsource so much of the implementation that you stop using implementation as a way of thinking**.

That leaves plenty of room for AI assistance. More than plenty, really.

Use it to research. Use it to draft specs. Use it to compare options. Use it to scaffold boilerplate. Use it to explain a code path back to you. Use it to write the first pass of a test you already understand. Use it to save time on the parts of the job that are genuinely repetitive.

Just do not confuse removing friction with removing the need to think through the work in its native material.

Because in software, the native material is still code.

## Final Thought

What I appreciate about Lars's post is that it is not really a call to abandon AI tooling. It is a call to be much more honest about what gets lost when we pretend coding is just execution and execution is therefore disposable.

I think he is right about that.

The best agentic workflows I have found do not replace coding with planning. They let planning, coding, and review tighten up around each other. The spec informs the work. The code reveals what the spec missed. The agent helps with the gaps. The human stays in contact with the thing being made.

That is slower than the marketing deck version.

It is also, I suspect, how you avoid becoming dependent on tools that gradually hollow out the judgment you needed to use them well in the first place.
