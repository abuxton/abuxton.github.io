---
layout: post
title: "How to Ask a Good Technical Question"
date: 2026-10-28 16:00:00 +0000
categories: [guides, communication]
tags: [questions, debugging, stackoverflow, github, ai, writing]
---

A good question gets a good answer faster. A vague one gets "can you share more details?" and a day of back-and-forth. This post is a short, stable guide I can link to whenever someone asks, "How should I ask for help with this?"

It applies to Stack Overflow, GitHub Issues, support forums, and team chat. Where a platform has its own rules, check them first.

## The pre-flight checklist

Copy this before you post:

- [ ] I searched for existing answers (docs, issues, release notes, search engine).
- [ ] I am asking in the right place for this kind of question.
- [ ] My title names the technology and the specific problem.
- [ ] I described what I want to happen and what actually happens.
- [ ] I listed what I already tried and what happened.
- [ ] I included a minimal reproducible example.
- [ ] Errors and output are pasted as text, not screenshots.
- [ ] I included versions, operating system, and relevant configuration.
- [ ] I removed secrets, tokens, and private data.
- [ ] I proofread it, and someone with no context could follow it.

## 1. Check the audience and search first

Decide who can answer. A bug in a library belongs in its issue tracker. A "how do I" question suits a Q&A site. A quick team-specific question suits chat. Then search: the error message, the docs, closed issues. If you find a near match that did not help, say so and explain why. That shows effort and saves responders from repeating it.

## 2. Write a specific, searchable title

Your title is the first thing people see, and what search engines index later.

- Weak: `Help, code not working`
- Better: `Terraform: "Error acquiring the state lock" when running plan in CI`

Include the tool, the symptom, and the exact error text where short.

## 3. Give context, expected and actual behaviour

Say what you are trying to achieve, not only the step that failed. Then state:

1. **Expected:** what you thought would happen.
2. **Actual:** what happened, including the exact error.
3. **Tried:** what you changed and how the result differed.

The goal sometimes differs from the approach you chose. Sharing it lets responders suggest a better route.

## 4. Provide a minimal reproducible example

A minimal reproducible example (MRE) is the smallest self-contained piece of code, config, or steps that still shows the problem.

Why it helps responders:

- **They can run it.** Reproducing the problem is the first step of diagnosis. Without it they guess.
- **It removes noise.** Cutting the example down to the failing part often shows you the cause.
- **It separates your bug from your environment.** If it fails for them too, the problem is in the code. If it passes, the difference (version, config) is the clue.
- **It makes answers checkable.** A fix can be tested against the same example.

To build one: copy the project, delete everything unrelated, replace real data with dummy values, and confirm the problem still occurs from a clean start.

Paste code, errors, and logs as formatted text in code blocks. Text can be searched, copied, and quoted; screenshots cannot.

````markdown
```text
Error: Error acquiring the state lock
```
````

## 5. Include environment and version details

Many problems depend on versions. Include the language or tool version, key dependencies, operating system, how you installed it, and how you ran the command. Relevant configuration helps; your whole repository does not.

## 6. Proofread, test, and follow up

Read the question as a stranger would. Could they reproduce it using only what you wrote? Follow your own steps in a fresh directory if you can.

After posting:

- Respond promptly and politely to clarifying questions.
- Edit the question with new details instead of burying them in replies.
- Say which answer worked, or post your own solution if you find one.
- Thank people, and close the loop.

## Using AI to prepare your question

AI assistants are useful before you ask a human. Used well, they help you find the answer, or help you write a better question.

- **Try the assistant first.** Paste your error and context. If it solves the problem, you are done. If not, you now have a list of things already tried.
- **Ask it to review your draft.** For example: "Here is my draft question. What is missing for someone to reproduce this? Suggest a clearer title. Do not invent details."
- **Ask it to shrink your example.** "Reduce this to a minimal reproducible example," then run the result yourself. AI output can be wrong, so confirm it still fails the same way.
- **Redact first.** Never paste secrets, tokens, or private data into an assistant or a public post.
- **Be honest.** If AI suggested something you tried, mention it. If you share AI-generated text, verify it. Many communities reject unverified machine-written answers and questions.

### Skills that can help

Agent skills package reusable instructions that an assistant loads for a task. If your tooling supports them, these are good fits:

- A writing skill such as [`writing-clearly-and-concisely`](https://github.com/abuxton/abuxton.github.io/tree/gh-pages/.agents/skills/writing-clearly-and-concisely) to tighten your draft.
- A markdown skill such as [`markdown-documentation`](https://github.com/abuxton/abuxton.github.io/tree/gh-pages/.agents/skills/markdown-documentation) to format code blocks and logs correctly.
- An issue-oriented skill such as [`issue-summary`](https://github.com/abuxton/abuxton.github.io/tree/gh-pages/.agents/skills/issue-summary) to condense a long thread into a clear problem statement.
- Your own small skill that encodes the checklist above, so an assistant can review any draft against it. See [`skill-creator`](https://github.com/abuxton/abuxton.github.io/tree/gh-pages/.agents/skills/skill-creator).

A skill does not replace your judgement. It is a second pair of eyes before you ask someone else for their time.

## Further reading

Stack Overflow's [How do I ask a good question?](https://stackoverflow.com/help/how-to-ask) is the source I drew on, and the authority for that platform's rules. This post is my own wording and extends it to other places you ask for help.

If someone sends you here: thank you for asking. Use the checklist, add what is missing, and post again.

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
