---
layout: post
title: "GitHub.com/abuxton — Profile Construction, Links, and Updates Over Time"
date: 2026-03-01 12:00:00 +0000
categories: [development, github]
tags: [github, profile, dotfiles, developer-tools, personal-branding]
---

GitHub profiles have become something of a personal homepage for developers. Mine at [github.com/abuxton](https://github.com/abuxton) has been through a fair few iterations, and I thought it was worth walking through what's there, how it got there, and how it connects to the rest of how I work.

## The Profile Repository

GitHub's special profile repository — the one where your `README.md` appears on your profile page — is [abuxton/abuxton](https://github.com/abuxton/abuxton). It is labelled plainly: *"profile repository holding page"*. Understated, but accurate.

The README is my attempt at a genuine, no-nonsense introduction. It opens with a multilingual welcome — a small reminder that the internet is global — and moves straight into who I am and what I do: a professional consultant focused on helping people solve their own problems, not solving problems for them. Teaching people to adopt new technologies — AI, agentic workflows, IaC, DevOps — is the throughline.

There is a line in there I like: *"My life is a constant round of 'could you, should you, and would you?' It's like 'kiss, marry, or avoid' but for technology-related products."* That about sums it up.

## The User Manual

One of the sections I find most useful on the profile is the **User Manual** — a table format borrowed from [Cassie Robinson's original idea](https://cassierobinson.medium.com/a-user-manual-for-me-d3a851fbc694). It covers:

- Conditions I like to work in
- The hours I prefer
- How I like to receive feedback
- Things I need
- Things I struggle with
- Things I love
- Other things to know about me

The practical upshot: I'm an early bird, I prefer Slack over screen grabs, and I'm Dyspraxic — which means people points are a real, finite resource. The further into the week it gets, the more introverted I become.

I put this on my profile because working well with people starts with telling them honestly how you work. Most teams spend months figuring this out the hard way. Publishing it upfront saves everyone time.

## Badges and Links

The profile includes a set of badges: the [Awesome](https://awesome.re) badge, Puppet Forge module count, Reddit karma (under my `adept2051` handle), GitHub followers, and a pair of license badges for [abuxton/.github](https://github.com/abuxton/.github) and [abuxton/dbad](https://github.com/abuxton/dbad) — the last of which is my port of the [Don't Be A Dick](https://dbad-license.org) open source licence.

Badges are cosmetic, but they are also a quick signal about where someone is active and what they care about. Puppet Forge presence says IaC. The DBAD licence says I believe open source is better when people are decent about it.

## The Reading List

Below the badges is a curated reading list that has accumulated over time. A few highlights worth repeating:

- [People are not resources](https://www.jrothman.com/mpd/management/2014/08/people-are-not-resources/) — a long-held belief that still needs saying.
- [The Scotty Principle](https://ipstenu.org/2011/the-scotty-principle/) — engineers consistently under-scope time and effort; if we applied Scotty's approach more often, we'd still be wrong, but by less.
- [Do-nothing scripting](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/) — the smartest piece I know on the *when* and *whether* of automation, not just the *how*.
- [Tenets of IT](https://github.com/DavidBrightSparc/Tenets-of-IT) — Taoism applied to modern engineering. Underrated.

## The Geekcard

The contact section points to the [Geek Card](./geekcard/README.md) — a small npm-based card (`npx digitaladept`) that outputs contact information in the terminal. This landed via [PR #1 — Feat-geekcard](https://github.com/abuxton/abuxton/pull/1) in October 2025. It is the kind of small, unnecessary thing that is entirely worth doing.

## The Dotfiles Connection

The profile does not exist in isolation. The [abuxton/dotfiles](https://github.com/abuxton/dotfiles) repository is what actually configures the environment I work in day to day, and the two are increasingly connected.

The dotfiles repository started as a fork of [Mathias Bynens' dotfiles](https://mths.be/dotfiles) and grew into something optimised for macOS, BSD, and ZSH. The classic structure — `.zshrc`, `.aliases`, `.functions.d/`, `bootstrap.sh`, `setup.sh` — remained stable for years.

Then, in February 2026, a significant set of changes arrived. A sequence of pull requests rewired the repository:

- **PR #1** — A major refactor adding agentic support configuration, introducing the `agents/` directory and `deploy-agents.sh` as a third deployment step alongside the existing `bootstrap.sh` and `setup.sh`.
- **PR #2** — CI workflow fixes to validate the dotfiles consistently.
- **PRs #4 and #5** — Validation hotfixes and workflow updates.
- **PR #7 — Feat/agent refactor** (25 Feb 2026): Consolidated the agent configuration support.
- **PR #8 — Add co-pilot instructions** (25 Feb 2026): GitHub Copilot-specific context arrived in the repository.
- **PRs #9, #10, #11, #12** (26–27 Feb 2026): A rapid series adding and refining the skills framework.
- **PR #13** (27 Feb 2026): Skills updated, completing the initial skills bundle.

The net effect: a two-script dotfiles setup became a three-step environment that deploys shell configuration *and* AI agent context in a single run. The `~/.agents/` directory it creates contains skills, prompts, and commands that any AI agent can use, with symlinks for Copilot, Claude, and OpenCode.

## Why the Profile and the Dotfiles Belong Together

The profile README is a document about how I work with people. The dotfiles are a document about how I work with machines. The skills framework is, increasingly, a document about how I work with AI agents.

They are all the same conversation, just addressed to different audiences. The user manual in the profile tells humans how to work with me effectively. The skills in `~/.agents/` tell AI agents the same thing — the conventions I prefer, the workflow patterns I follow, the tools I use.

The [Ghost Engineer note](https://x.com/yegordb/status/1859290734257635439) on the profile captures the underlying point. The work that statistics and commit counts don't show — the explaining, tutoring, collaborating, communicating — is the most important work. The AI tooling I have been building into my environment is intended to augment that work, not replace it.

## Where to Find Everything

- Profile: [github.com/abuxton](https://github.com/abuxton)
- Dotfiles: [github.com/abuxton/dotfiles](https://github.com/abuxton/dotfiles)
- Geek Card: `npx digitaladept`
- Skills: [github.com/abuxton/SKills](https://github.com/abuxton/SKills)
