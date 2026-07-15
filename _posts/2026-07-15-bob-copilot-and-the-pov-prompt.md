---
layout: post
title: "Bob, Copilot, and the PoV Prompt"
date: 2026-07-15 13:35:27 +0000
categories: [ai, development]
tags: [github-copilot, ibm-bob, pov, prompt-engineering, code-review, terraform, agents]
---

I have access to both GitHub Copilot and IBM Bob through work, and every now and then I do the same slightly unfair but very revealing thing: I give them roughly the same prompt and see what comes back.

That is especially useful when I am rushing an idea through proof-of-value stage. At that point I am not looking for pristine architecture. I am looking for shape, momentum, and whether the tool helps me think or merely helps me type.

This time the Bob output was this gist: [Terraform Multi-Team Resource Example with Tag-Based Preconditions](https://gist.github.com/abuxton/da462a80a51533177f0dbe23dd51a9a7).

## Two Coding Assistants, Two Public Faces

| Tool | Visual | What its public material emphasizes |
| --- | --- | --- |
| GitHub Copilot | <img src="/assets/img/posts/bob-copilot-pov/github-mark.png" alt="GitHub icon" width="32"> | Broad platform reach: IDE, CLI, GitHub, mobile, chat, PR support, and agentic workflows |
| IBM Bob | <img src="/assets/img/posts/bob-copilot-pov/ibm.svg" alt="IBM icon" width="48"> | IDE-centered agent experience: modes, task lists, approvals, review flows, and guided automation |

*Icon sources: [GitHub brand asset](https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png) and [IBM logo SVG from IBM's GitHub organization](https://github.com/IBM/video-summarizer-using-watson/blob/3e371b275a34ecb5a5cbcbd58f1531534889fd4c/overrides/.icons/simple/ibm.svg).*

![GitHub Copilot social card from GitHub Docs](/assets/img/posts/bob-copilot-pov/copilot-social-card.png)
*Source: [GitHub Docs — What is GitHub Copilot?](https://docs.github.com/en/copilot/get-started/what-is-github-copilot)*

![IBM Bob code review screenshot from IBM tutorial content](/assets/img/posts/bob-copilot-pov/bob-completed-code-review.png)
*Source: [IBM tutorial — LLM code review using IBM Bob](https://github.com/IBM/ibmdotcom-tutorials/blob/edb8773b3b97781060ac80a2e75a66246c1ca9ba/tutorials/16-ibm-bob/llm-code-review-ibm-bob/llm-code-review-ibm-bob.md)*

GitHub's own documentation presents Copilot as a very wide platform product: suggestions in the IDE, chat, command line help, shared context through Spaces, pull request assistance, and now agentic workflows that can research, plan, code, and open PRs for review.

Bob's official public entry points are different: the [product page](https://www.ibm.com/products/ai-coding-agent), the [Bob blog](https://bob.ibm.com/blog), and IBM's public tutorials that show it acting inside an IDE with named modes, slash commands, approval steps, task lists, code review, documentation work, and deployment flows. The strongest public picture I could verify was in IBM's own Bob walkthroughs for [documentation work](https://github.com/IBM/ibmdotcom-tutorials/blob/edb8773b3b97781060ac80a2e75a66246c1ca9ba/tutorials/16-ibm-bob/ai-docs-ibm-bob/ai-documentation-with-ibm-bob.md), [code review](https://github.com/IBM/ibmdotcom-tutorials/blob/edb8773b3b97781060ac80a2e75a66246c1ca9ba/tutorials/16-ibm-bob/llm-code-review-ibm-bob/llm-code-review-ibm-bob.md), and [deployment](https://github.com/IBM/CodeEngine/blob/73dc401c3705578bbb39a79e685cf25b097ede44/content/posts/deploy-from-bob/index.md).

That difference matters. Copilot's public message is ecosystem breadth. Bob's public message is guided task execution inside a development environment.

## What Bob Produced

The gist is not just a single file. It is a small PoV bundle:

- Terraform for a shared-resource pattern
- variables and outputs
- team-specific `tfvars`
- a `.gitignore`
- a validation shell script
- a long README explaining intent, usage, testing, and extension points

In plain English, the idea is this: two teams can run the same Terraform, and the second team should detect that the shared resource already exists instead of creating a duplicate.

That is a good PoV instinct. It is trying to solve a real coordination problem, not just generate syntax.

## The Short Summary

My summary of the Bob output is:

- **good at shape**
- **good at packaging**
- **good at making a PoV feel complete**
- **less reliable on the exact mechanics than the confidence of the prose suggests**

That is not a trivial criticism. It is also not a dismissal. A lot of PoV work lives or dies on whether the first draft has enough structure to react to. This one does.

## What I Like About The Gist

The strongest thing about the output is that it thinks in artifacts, not fragments.

Bob did not stop at `main.tf`. It produced:

- the implementation
- supporting variables
- outputs
- example team inputs
- validation scaffolding
- documentation

That is often exactly what you want in early-stage agentic help. Not perfection. Coverage.

I also think the README is doing something useful. It explains the intended pattern clearly enough that a human reviewer can challenge the design instead of first having to reverse-engineer the intent. That matters.

And for a rushed PoV, "something coherent enough to discuss" is a real milestone.

## Where The Gist Starts To Creak

The weak point is that some of the implementation detail does not fully support the confidence of the surrounding explanation.

### 1. The "precondition" story is overstated

The README frames this as a tag-based precondition pattern, but the actual behavior is mostly driven by `count = local.should_create ? 1 : 0`.

If `local.should_create` is false, the bucket resource is not created at all, so the lifecycle precondition is not the thing doing the main stopping. The design still expresses the intent, but the explanation over-credits the precondition.

### 2. One data source looks brittle and effectively unused

The `data "aws_s3_bucket" "existing"` block checks `local.bucket_name`, but the rest of the logic really depends on scanning buckets and comparing tags. That `existing` data source does not drive the main flow, and the comment about handling non-existence through lifecycle logic is not very convincing. A failed data read is not the same thing as a graceful existence check.

### 3. The output contract is confusing

When Team 2 finds an existing bucket, `bucket_name` still reflects Team 2's computed name rather than the already-existing shared bucket that matched the tags.

That is fine for a draft, but confusing for a real pattern. If the point is "use the shared thing that already exists", then the ergonomics should surface the actual existing resource more directly.

### 4. The README sounds more production-ready than the code really is

This is the classic AI draft tell.

The documentation is comprehensive, polished, and broad. The implementation is plausible. But they are not perfectly aligned in rigor. The README reads like the pattern is settled. The Terraform reads more like a solid discussion starter.

That is very normal for LLM-assisted output. It is also exactly why review still matters.

## What This Says About Bob

From this example, Bob looks strong at:

- creating a believable end-to-end first draft
- wrapping code in explanation and process
- making an idea easy to review as a package
- getting from prompt to "something we can discuss" quickly

That fits the public IBM material too. In IBM's tutorials, Bob is shown as a tool that reads the repo, builds a task list, works through approvals, performs code review, proposes fixes, and helps with documentation and deployment.

So the Bob personality, at least from what I can observe publicly, is less "inline autocomplete" and more "guided task-oriented coding agent".

## What This Says About Copilot

GitHub's own documentation positions Copilot differently.

Copilot is available across more surfaces and more access models. Publicly documented access includes free and paid individual plans, enterprise routes, IDE usage, GitHub UI usage, terminal usage, mobile chat, shared context, PR descriptions, and agentic task execution.

That gives Copilot a different kind of strength:

- easier self-serve access
- tighter integration with the GitHub platform itself
- broader workflow coverage in public docs
- a cleaner path from research to code to PR inside one ecosystem

In other words, Copilot feels like platform infrastructure. Bob, from the material I could verify, feels more like a specialized working environment.

## My Practical Comparison

If I am rushing a thought through PoV stage, the difference I care about is not brand. It is failure mode.

### Bob's likely failure mode

Bob seems inclined to give you a fairly complete package quickly, which is great for momentum, but it increases the chance that the polish of the package outruns the precision of the implementation.

### Copilot's likely failure mode

Copilot's broad integration can make it feel like the more convenient day-to-day companion, but convenience can also encourage people to accept generated fragments without stepping back to inspect whether the whole design hangs together.

So for me:

- **Bob looks good for producing a discussable PoV bundle**
- **Copilot looks good for staying embedded in the actual day-to-day engineering surface area**

Neither of those removes the need for judgment.

## Final Thought

The most interesting thing here is not "which one wins?"

It is that both tools change what good early-stage engineering looks like.

The hard part is no longer only writing enough text into enough files. The hard part is:

- asking for the right thing
- noticing where the draft overclaims
- separating a useful pattern from a convincing illusion
- turning an AI-shaped first pass into an actually trustworthy design

Bob's gist is a good example of that. It is useful. It is thoughtful. It is faster than starting from nothing. It is also not something I would merge unreviewed.

That, to me, is the real comparison.

Copilot is the broader public platform with more explicit self-serve reach and GitHub-native workflow coverage. Bob, at least from the outputs and public IBM walkthroughs I can inspect, is a strong guided agent for packaging ideas into a workable first draft.

For PoV work, both are valuable.

But the leverage is still in the review.
