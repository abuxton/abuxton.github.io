---
layout: post
title: "GitHub Profile: Construction, Links, and Dotfiles Evolution"
date: 2026-03-02 12:00:00 +0000
categories: [github, development]
tags: [github, dotfiles, profile, open-source]
---

A GitHub profile is often the first thing people see when they find you online in the developer world. Over the years mine has gone through several iterations — from a bare profile with a handful of repos to something that (hopefully) tells a clearer story about how I work and what I care about.

This post covers how I built out my [GitHub profile](https://github.com/abuxton), the pinned repositories I chose and why, and the evolution of my dotfiles from a simple fork to a fully redeveloped setup built around modern practices.

## The GitHub Profile README

GitHub lets you create a special repository named after your username — in my case [`abuxton/abuxton`](https://github.com/abuxton/abuxton) — and the `README.md` in that repo is displayed at the top of your profile page. It's a deceptively simple feature with a lot of creative potential.

My goals for the profile README were straightforward:

- **Introduce myself** without writing an essay
- **Link to things I'm actually proud of** rather than just defaulting to pinned stars
- **Signal what I work on** so visitors can quickly orient themselves

I kept it concise: a short bio, links to this blog, and a handful of badges that reflect where I spend most of my time. Resist the urge to fill it with auto-generated stats widgets — they add noise without signal.

## Pinned Repositories

Pinned repos are prime real estate. GitHub allows up to six, and choosing them thoughtfully matters. Mine have changed over time, but the selection criteria have stayed consistent:

1. **Active projects** — Things I'm currently working on or maintaining
2. **Representative work** — Projects that show range across languages and problem domains
3. **Useful to others** — Repos someone else might fork or learn from

One of the repos that has lived on my profile for a long time is my dotfiles repository. It started as a fork and grew into something much more considered.

## Dotfiles: From Fork to Redevelopment

### What Are Dotfiles?

Dotfiles are configuration files for your shell, editor, and tools — named with a leading `.` on Unix-like systems (e.g. `.bashrc`, `.gitconfig`, `.vimrc`). Keeping them in a version-controlled repository means your environment is reproducible, shareable, and recoverable.

Storing dotfiles publicly on GitHub has become a common practice. You can browse [GitHub's unofficial dotfiles guide](https://dotfiles.github.io/) to see the variety of approaches people take.

### Starting with a Fork

Like many developers, I started by forking someone else's dotfiles repository. At the time this was the fastest way to get a working setup with sensible defaults — aliases, a prompt that showed git status, editor configuration, and a basic bootstrap script.

The problem with a fork as a long-term strategy is that it accumulates drift. The upstream moves in directions you don't care about, your local changes pile up without structure, and the whole thing becomes harder to reason about. What was someone else's preferences gradually became a patchwork of mine, poorly documented and brittle.

### Redeveloping with Modern Practices

When I decided to rebuild my dotfiles from scratch I took the opportunity to apply some practices I'd developed working on larger software projects:

**1. Idempotent install scripts**

The bootstrap script should be safe to run multiple times. Whether it's the first install or a re-run on an existing machine, the result should be the same. This means checking for the existence of symlinks before creating them, using package manager flags like `--no-clobber`, and avoiding side effects that accumulate on repeated runs.

**2. Separation of concerns**

Rather than one enormous `.bashrc`, I split configuration by concern: shell aliases in one file, environment variables in another, tool-specific configuration in dedicated files loaded conditionally. This makes it much easier to trace where a behaviour comes from when something unexpected happens.

**3. XDG Base Directory compliance**

The [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) defines standard locations for config, data, and cache files (`~/.config`, `~/.local/share`, `~/.cache`). Moving tool configuration to `~/.config/<tool>` where supported keeps the home directory clean and makes the structure predictable.

**4. Machine-local overrides**

Not every machine needs the same configuration. Work laptops have different requirements to personal machines or servers. I added a pattern for local overrides — files that are sourced if they exist but are `.gitignore`d, so machine-specific secrets and settings never make it into the repository.

**5. README-driven**

The README isn't an afterthought. It documents what the repo contains, how to install it, and what decisions were made and why. When I come back to this in six months I want to understand it quickly, and so does anyone who finds it useful.

### The Result

The rebuilt [`abuxton/dotfiles`](https://github.com/abuxton/dotfiles) repository is smaller, cleaner, and — most importantly — something I actually understand end to end. Starting from a fork was the right move for getting productive quickly; rebuilding from scratch was the right move for long-term maintainability.

## Keeping the Profile Current

A GitHub profile is a living document. I revisit mine periodically to:

- Swap out pinned repos as projects come and go
- Update the README bio when my focus shifts
- Review which contributions are visible and in what order

If you haven't thought about your GitHub profile as something worth maintaining, it's worth spending an afternoon on. It's often the first place a recruiter, collaborator, or curious engineer lands before deciding whether to reach out.

---

*Have thoughts on dotfile management or GitHub profile strategies? The repo for this blog is [public](https://github.com/abuxton/abuxton.github.io) — issues and pull requests welcome.*
