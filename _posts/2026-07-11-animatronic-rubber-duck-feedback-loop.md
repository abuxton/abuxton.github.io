---
layout: post
title: "The Animatronic Rubber Duck and the Solo Developer Feedback Loop"
date: 2026-07-11 09:00:00 +0000
categories: [ai, development]
tags: [ai, agents, rubber-duck-debugging, chat-mode, prompting, spec-driven-development, debugging, solo-development]
---

Joe Beda's post, [The animatronic rubber duck](https://joe.dev/posts/animatronic-rubber-duck/), is excellent. Not because it claims AI has become a magical collaborator, but because it finds a better description for one of the most useful ways to work with it.

Classic rubber duck debugging works because you are forced to explain what you think is happening. The duck contributes nothing except the demand that you make your thinking explicit. A chat model changes that dynamic. It does not stay silent. It asks the obvious question you skipped. It notices the edge case you quietly stepped around. It reflects your explanation back at you in a slightly different shape. "Animatronic rubber duck" is a very good name for that. It keeps the useful humility of the original metaphor while admitting that the duck now twitches and talks back.

That matters, because a lot of the worst AI discourse still swings between two bad ideas:

- the model is just autocomplete and therefore trivial
- the model is a substitute for understanding and therefore revolutionary

Joe's framing lands in the more useful middle. The value is not that the machine knows your codebase better than you do. It is that it can participate in the loop of explanation, objection, and refinement quickly enough to help you think better while you are still in the problem.

## What The Post Gets Right

The strongest point in the piece is that the interaction is most useful when it builds *your* understanding rather than replacing it.

That matches my experience almost exactly. The best chat-mode sessions are not "build the whole thing for me" sessions. They are the ones where I am half sure of the shape of the problem, and the agent is good enough to keep pressure on the bits that are still vague. It is an active listener with infinite patience and no ego. That turns out to be surprisingly powerful.

I also like the way the post resists over-romanticising the tool. "Animatronic" is doing a lot of work. It says: this is not a colleague, not a peer, not a mind in the human sense. But it is responsive enough that the old silent-duck metaphor no longer quite fits. That is exactly the register I prefer for this whole area: useful, sometimes uncanny, and best handled without pretending the machine is more than it is.

## Where I Keep Using This Pattern

Reading it, I realised how much of my own work across my repositories now follows this shape.

### Prompt Development

The first place is prompt development itself.

In this blog repository, and in the wider workflow I use around it, a prompt is rarely a one-shot command anymore. It is usually the start of a conversation. I give the agent a rough instruction, see where it overreaches or misunderstands, tighten the boundaries, sharpen the tone, clarify the acceptance criteria, and go again. That is not me delegating thought. That is me thinking with resistance.

I wrote earlier about how AI has changed my ability to write again, especially by lowering the friction between a half-formed idea and a finished draft. What Joe's post adds is a better explanation for *why* that can work so well. The chat loop is not only producing text. It is helping me discover what I actually mean before I commit to it.

That has shown up in my skills work too. When I have been building promptable workflows and agent skills, the useful sessions were almost always the ones where I treated the model as something to argue the shape into, not something to hand the whole problem to and hope for the best.

### Spec Driven Development

The second place is spec driven development.

I have written very recently about the limits of pretending that coding can be reduced to planning, and I still think that matters. But a spec, a task list, or a structured prompt can still be extremely useful if you treat it as something to be interrogated.

This is where the animatronic duck really earns its keep. You draft the spec. The agent asks what happens on failure. It points out an ambiguity in ownership, state, naming, or sequencing. It exposes the line you wrote because it sounded complete rather than because it was complete. That is not implementation yet, but it is real engineering work. It is the kind of back-and-forth that makes the eventual implementation better.

Used well, the feedback loop is:

- write the intent down
- let the agent push on the weak points
- tighten the spec
- implement close enough to the code that your own understanding keeps increasing

That is a much healthier model than "write giant spec, ask agent to disappear into the mist, review the result later".

### Debugging Real Projects

The third place is debugging, especially in my tool repos.

When I was building `tf-slate`, the parts that went smoothly were often the obvious scaffolding. The parts that needed more care were the interactive flows, test behaviour, and release edges where reality got awkward. Those are exactly the moments where chat mode is most valuable to me. Not because the agent always knows the answer, but because it keeps the debugging session moving. Explain the failure. Show the output. Answer the follow-up. Get a candidate hypothesis back. Try again.

That loop is also useful when the bug is really a gap in the model in my own head. Sometimes the act of answering the agent's questions is what reveals that I never quite understood the boundary between two components, or that I had silently assumed some tool behaved the same on macOS and Linux when it absolutely did not.

It is rubber duck debugging with a second pass attached.

## The Feedback Loop Is The Product

Part of the charm of AI and agents, when they work well, is exactly this feedback loop.

Not just faster output. Not just cheaper drafts. The loop itself.

You say what you are trying to do. The system responds. You refine. It pushes back. You notice something. It notices something else. Very quickly you are no longer staring at a blank screen or trapped in your own first explanation of the problem. You are in motion.

For a lone developer, that is a big deal.

There are many forms of software work that are easier simply because another person is present to sanity-check the plan, ask the annoying question, or listen while you untangle the problem out loud. If you work mostly on your own, you do not always have that available on demand. An agent in chat mode is not a replacement for a good teammate, but it can be a very good substitute for the *function* of immediate feedback when what you need is friction, reflection, or a second pass.

That is one reason I think these tools have landed so strongly for solo builders. They compress the distance between idea, objection, revision, and next attempt. They give you a way to stay in the loop without having to wait for another human to become available.

## But Only If You Stay In Contact With The Work

The catch, as ever, is that this only works if you keep your own judgment switched on.

If the chat loop becomes a way to avoid understanding, it stops being a duck and starts being a slot machine. You can still get plausible answers out of it, sometimes very convincing ones, but the benefit Joe is describing depends on the human actually doing the explanatory work. The model helps because it makes your thinking more explicit and more testable. If you stop thinking, the loop collapses.

That is why I think the animatronic duck is such a helpful image. It frames the tool correctly. Useful. Responsive. Not wise. Not autonomous. Not the author of understanding.

## Final Thought

I like Joe's post because it describes one of the most practical, least theatrical uses of AI.

Use the agent in chat mode when you need a fast feedback loop.
Use it to pressure-test a prompt.
Use it to pull weak spots out of a spec.
Use it to talk through a bug until the shape of the problem becomes obvious.

For a solo developer especially, that is real leverage.

Not because the duck became a person.

Because it learned, just enough, how to talk back.
