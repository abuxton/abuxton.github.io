---
layout: post
title: "How to Ask a Good Technical Question"
date: 2026-10-28 16:00:00 +0000
categories: [guides, communication]
tags: [questions, debugging, stackoverflow, github, ai, writing]
---

A good question gets a useful answer faster. When you ask for help, the person reading cannot see your screen, project, or the steps that led to the problem. Your job is to close that gap.

This guide is a short, stable link for anyone wondering how to ask for technical help. It applies to Stack Overflow, support forums, team chat, and issue trackers. Each community has its own rules, so read them first. For a reminder of how support conversations can go wrong, see XKCD's *Tech Support*:

[![XKCD's Tech Support comic](https://imgs.xkcd.com/comics/tech_support.png "I recently had someone ask me to go get a computer and turn it on so I could restart it. He refused to move further in the script until I said I had done that.")](https://xkcd.com/806/)

*XKCD's [“Tech Support”](https://xkcd.com/806/), by Randall Munroe.*

## Before you post

Run through this checklist:

- [ ] I searched the documentation, error message, existing issues, and release notes.
- [ ] I chose a place that accepts this kind of question.
- [ ] My title names the technology and the specific problem.
- [ ] I explained what I am trying to do, what I expected, and what happened instead.
- [ ] I said what I already tried and what each attempt changed.
- [ ] I included a minimal reproducible example.
- [ ] Errors and output are pasted as text, not screenshots.
- [ ] I included relevant versions, my operating system, and configuration.
- [ ] I removed secrets, tokens, and private data.
- [ ] Someone with no context could follow it.

## Start in the right place

Decide who is best placed to answer. A confirmed bug in a library may belong in its issue tracker; a "how do I" question may suit a Q&A site; a team-specific question may belong in chat. Check the project's contribution, support, or issue template guidance before opening an issue.

Search before you ask. Search the exact error message, the documentation, release notes, and closed issues. If you find a similar question that did not solve your problem, link to it and explain what differs. That saves people from repeating an answer you have already tried.

## Give people a question they can answer

Use this outline:

> I am trying to **[goal]**.
>
> When I **[command, action, or code]**, I expected **[result]**.
>
> Instead, **[actual result or exact error]** happened.
>
> I have already tried **[steps]**, which resulted in **[outcome]**.
>
> I am using **[tool and version, operating system, and relevant configuration]**.
>
> Here is the smallest example that still reproduces the problem: **[code or steps]**.

You do not need to include everything you know. Include the details that let another person understand and investigate the problem without guessing.

## Write a title people can find

Your title is the first thing people see and what search engines index later. Name the technology and the specific symptom.

- Weak: `Help, code not working`
- Better: `Terraform: "Error acquiring the state lock" when running plan in CI`

Include a short exact error in the title when it helps. Leave the full output for the body.

## Make the problem reproducible

A minimal reproducible example (MRE) is the smallest self-contained piece of code, configuration, or steps that still shows the problem. It gives people something they can run instead of a problem they have to infer.

Building one often helps you too. Remove everything unrelated, replace real data with safe dummy values, and confirm the problem still happens from a clean start. If another person cannot reproduce it, comparing your versions, configuration, and steps can still narrow down the difference.

Paste code, errors, and logs as formatted text in code blocks. Text can be searched, copied, and quoted; screenshots cannot.

````markdown
```text
Error: Error acquiring the state lock
```
````

## Check it from a stranger's point of view

Read the question as a stranger would. Could they reproduce the problem using only what you wrote? If you can, follow your own steps in a fresh directory. Include the language or tool version, key dependencies, operating system, installation method, and relevant configuration. Do not paste your whole repository when a focused extract will do.

After posting, answer clarifying questions, add new details to the question rather than burying them in replies, and say which answer solved the problem. Close the loop for the next person who finds it.

## Use AI as a drafting aid

An AI assistant can help you find missing context, suggest a clearer title, or reduce an example. It does not replace checking the result yourself.

- Ask it to review a draft: “What information is missing for someone to reproduce this? Suggest a clearer title. Do not invent details.”
- Ask it to reduce an example, then run the result and confirm it fails in the same way.
- Redact secrets, tokens, and private data before sharing anything.
- Verify every suggestion before you include it in a public question.

## Further reading

Stack Overflow's [How do I ask a good question?](https://stackoverflow.com/help/how-to-ask) is the authority for that platform's rules. This post uses original wording and extends the same principles to other places where people ask for help.

If someone sends you here, thank you for asking. Add what is missing, then post a question someone can answer.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
