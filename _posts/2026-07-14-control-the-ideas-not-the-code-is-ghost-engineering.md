---
layout: post
title: "Control the Ideas, Not the Code Is Ghost Engineering"
date: 2026-07-14 08:47:15 +0000
categories: [engineering, ai]
tags: [ghost-engineering, shadow-engineering, antirez, ai, agents, agentic-workflows, collaboration, design, code-review, enablement]
---

I have just read Salvatore Sanfilippo's post, [Control the ideas, not the code](http://antirez.com/news/169), and I think it is one of the sharper pieces yet on what AI is actually changing in software engineering.

Not because it is telling people to stop caring about quality. Quite the opposite. What it is really arguing is that the scarce resource is no longer keystrokes. It is judgment. It is taste. It is design. It is knowing what software should exist, how it should behave, what trade-offs are acceptable, where the failure modes are, and how to test the thing hard enough to trust it.

That is very close to what I have been calling [shadow engineering](/engineering/community/shadow-engineering/enablement/2026/04/07/shadow-engineering-the-invisible-work-that-matters.html), and to the older provocation behind the phrase ghost engineering: the most valuable work in software is often not the work that shows up cleanly in a commit graph.

## The Core Of Antirez's Argument

Antirez's case, in simple terms, is this:

- AI can generate a large volume of locally competent code very quickly.
- Reviewing that code line by line is becoming a worse trade for senior engineers.
- The higher-value work is controlling the ideas: design, intent, architecture, correctness, QA, and the mental model behind the system.
- If you have limited hours in the day, spending them on the conceptual layer may now create more value than spending them reading every generated function.

That is a much stronger claim than "AI makes coding faster." It is a claim about what the job *is*.

He is also careful, and this matters, not to reduce the whole thing to blind vibe coding. He is not saying "ask for a product and pray". He is saying that if you understand the system deeply enough, your attention is often better spent steering, testing, and refining the design than performing exhaustive ritual review of code that is increasingly machine-produced.

That distinction is important. The point is not the abandonment of rigor. The point is the relocation of rigor.

## Why This Sounds Like Ghost Engineering To Me

What I hear in this post is a defence of the kind of engineering work that remains hard to count, hard to attribute, and easy to undervalue.

If the real leverage now sits in:

- deciding what to build
- shaping the design
- spotting bad assumptions early
- writing the design notes that let others inherit the mental model
- asking better questions of the system and the tools
- doing the QA that proves the thing works

then we are back in the territory that metrics people have always struggled with.

None of that shows up neatly in "lines changed". Only some of it shows up in PR count. A lot of it looks, from the outside, like talking. Or note writing. Or asking annoying questions in review. Or spending an afternoon turning half-formed intuition into a clearer architecture. In other words: ghost engineering.

That has been true for a long time. AI just makes the mismatch harder to ignore.

When a machine can produce the visible artifact faster, the invisible parts of engineering become easier to see for what they always were: not overhead, but the work that decides whether the artifact is worth producing at all.

## You Cannot Track All Value In Commits

This is the part of the post that connects most directly to ideas I have been circling on this blog for months.

The old mistake was to assume commit history maps cleanly to value. The new mistake would be to assume that because AI is generating more of the code, the human is somehow contributing less. In many cases the reverse is true. The human contribution shifts upward into judgment, system design, task framing, review strategy, test design, and collaborative sense-making.

That work is less visible precisely because it is upstream.

The conversation that prevents the wrong feature being built is more valuable than the commit that implements the wrong feature elegantly.

The design note that lets a team modify a system six months later is more valuable than the pristine function nobody understands well enough to change safely.

The QA pass that catches a broken assumption is more valuable than a day's worth of generated code that looked convincing until it met reality.

All of those are forms of shadow work. All of them are easy to miss if your model of productivity is still centered on direct output.

## Agentic Workflows Increase The Value Of Talking

This is where I think AI agents and agentic workflows create something genuinely interesting.

A lot of the sales pitch around agents has focused on replacing implementation effort. Fine. That part is real enough. But the more important shift may be that they make ideation, collaboration, and explanation newly valuable.

If an agent can turn a good design conversation into a first draft of implementation, then the conversation itself becomes higher leverage.

If a shared mental model can be turned into scaffolding, tests, documentation, or a design file quickly, then the act of building that mental model together becomes more economically important.

If the machine is strong at producing locally competent code, then the human advantage moves even further toward:

- framing the problem well
- transferring context clearly
- spotting what does not belong
- deciding what quality means in this case
- mentoring others into better judgment

That is not the end of engineering. It is a return to one of the oldest parts of engineering: talking through ideas, challenging assumptions, making trade-offs explicit, and giving shape to half-seen possibilities before they solidify into systems.

The freedom AI gives us, at its best, is not freedom from thought. It is freedom to spend more of our effort where thought compounds.

## Where I Think The Post Is Strongest

The strongest point in Antirez's post is the insistence that quality and conceptual control matter more, not less, in an AI-heavy workflow.

That lines up with my own experience. The best use of agents is not "leave me alone and come back with a finished codebase." It is tighter loops around intent:

- help me explore options
- help me sketch the shape
- help me draft the boring parts
- help me document the design
- help me test the assumptions
- help me check the edge cases

The more capable the agent gets, the more valuable it becomes to have a human who can keep the whole effort coherent.

That is why I do not see ghost engineering as being displaced by AI. I see it being made more central. The engineer who can hold the mental model, explain it, and share it across a team becomes more useful, not less.

## Where I Would Add Some Caution

I do not think "control the ideas, not the code" means code stops mattering.

It means the relationship changes.

There are still cases where direct engagement with code is the fastest way to discover that your idea was wrong. I wrote recently that [coding is planning](/ai/development/2026/07/08/coding-is-planning.html), and I still believe that. Sometimes implementation is how the design reveals its missing pieces. Sometimes the friction of touching the actual structure is what produces understanding.

So I would read Antirez's argument less as "never look at code" and more as "stop assuming line-by-line code inspection is always the highest-value use of senior attention."

That feels right to me.

I also think his note about younger engineers is an important unresolved issue. People still need to learn how software works. They still need to build the instincts that let them judge whether an agent has done something clever, brittle, dangerous, or simply wrong. That does not happen by magic. It probably still requires writing, breaking, fixing, and understanding real programs.

But even there, the conclusion is not that every professional workflow should stay frozen in a pre-AI model. It is that learning and production may need different shapes.

## Final Thought

What I like about this post is that beneath the provocation there is a defence of engineering as a conceptual, collaborative, judgment-heavy discipline.

That is ghost engineering.

It is the architecture conversation, the design document, the explanation, the review that teaches, the QA pass, the test strategy, the sense of where the system should go next, and the quiet work of making sure other people can inherit the ideas instead of just the files.

AI agents do not make that work disappear. They make its value harder to deny.

If code generation gets cheaper, then the ability to control ideas, transfer understanding, and collaborate well becomes a bigger share of the real job.

And that is good news for those of us who never believed the commits were the whole story in the first place.
