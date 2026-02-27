# AGENTS — Agent-Agnostic Workflow Guide

This guide explains how to work with this Ruby/Jekyll blog project using OpenSpec, an artifact-driven workflow system. Use this regardless of which agent interface you're using (GitHub Copilot, OpenCode, Claude, or any other agent).

## Project Context

**Repository:** `abuxton/abuxton.github.io`
**Published at:** [http://blog.abcdevelopment.co.uk](http://blog.abcdevelopment.co.uk)
**Technology:** Ruby, Jekyll, GitHub Pages
**Blog branch:** `gh-pages` — all published content lives here
**Development branch:** `main` — source, Makefiles, Jekyll configuration

This is a Jekyll-based static blog. New blog posts are Markdown files placed in `_posts/` on the `gh-pages` branch following Jekyll naming convention: `YYYY-MM-DD-title-slug.md`.

### Quick Reference: Common Tasks

| Task | Command |
|------|---------|
| Serve locally | `make jekyll-serve` |
| Build site | `make jekyll-build` |
| New post | `make new-post title="My Title"` |
| Deploy to gh-pages | `make deploy-gh-pages` |
| Install dependencies | `make bundle-install` |

---

## Overview

Agents are expected to be used for a variety of projects and we would like to establish a standardised approach utilising a mix of agent skills and Spec driven deployment in any development environment setup. Work is organized using **OpenSpec**, an artifact-driven workflow that structures development into well-defined phases:

1. **Proposal** — What you want to build and why
2. **Specs** — Technical requirements and acceptance criteria
3. **Design** — Architecture and implementation approach
4. **Tasks** — Concrete, actionable work items
5. **Implementation** — Code changes and deployment

This structure enables methodical progression from planning through completion.

### What Makes This Repository Agent-Aware?

- **Unified agent resources:** All skills, commands, prompts, and configuration in `~/.agents/`
- **Local development:** During development, resources are in `.agents/` within project
- **Deployable structure:** Copy entire `.agents/` directory to `~/.agents/` for system-wide access
- **Multiple agent types:** Supports Claude, Copilot, OpenCode, and custom integrations
- **Idempotent operations:** Safe for both autonomous and human decision-making
- **Clear phase documentation:** Bootstrap, setup, validation, optional features
- **Artifact-driven workflow:** OpenSpec structures complex changes consistently

### Key Concepts

- **Change**: A unit of work (feature, fix, refactor) organized in `openspec/changes/<change-name>/`
- **Artifact**: Structured documents that guide implementation (proposal, specs, design, tasks)
- **Schema**: A workflow template that defines which artifacts are needed and their sequence
- **Skills**: Agent-specific instructions for performing OpenSpec operations

---

## Jekyll Blog Conventions

### Writing a New Blog Post

Blog posts live in `_posts/` on the `gh-pages` branch and follow this naming convention:

```
_posts/YYYY-MM-DD-my-post-title.md
```

Every post requires front matter at the top:

```yaml
---
layout: post
title: "My Post Title"
date: YYYY-MM-DD HH:MM:SS +0000
categories: [category1, category2]
tags: [tag1, tag2]
---
```

Use `make new-post title="My Post Title"` to scaffold a new post file.

### Categories Used

- `update` — general site/project updates
- `development` — software development topics
- `github` — GitHub-specific topics
- `ai` — AI tools and skills
- `ruby` — Ruby and Jekyll topics

### Content Style

- Write in clear, conversational Markdown
- Use headings (`##`, `###`) to structure longer posts
- Include code blocks with language hints (` ```ruby `, ` ```bash `, etc.)
- Keep posts focused on a single topic
- Reference related posts and projects where relevant

---

## Available Skills

All skills are available in a unified location. The path depends on your context:

**Development (in project):**
- **Location:** `./.agents/skills/`
- **Commands:** `./.agents/commands/`
- **Prompts:** `./.agents/prompts/`
- **Configuration:** `./.agents/settings.json`

**Deployed (system-wide):**
- **Location:** `~/.agents/skills/`
- **Commands:** `~/.agents/commands/`
- **Prompts:** `~/.agents/prompts/`
- **Configuration:** `~/.agents/settings.json`

Access available skills:

```bash
# During development (in project)
ls ./.agents/skills/

# After deployment to home directory
ls ~/.agents/skills/
```

### 🎯 Key Skills for this Project

#### `jekyll-blog`
**Jekyll blog post creation, site management, and content workflow**

Use when: Writing new posts, managing categories/tags, configuring Jekyll, deploying to gh-pages

#### `writing-clearly-and-concisely`
**Expert guidance for clear, engaging technical writing**

Use when: Drafting or editing blog posts, improving readability

#### `markdown-documentation`
**Markdown best practices for structured documentation and blog content**

Use when: Formatting posts, creating tables, code blocks, and rich content

#### `user-story-writing`
**Transform ideas into structured stories**

Use when: Planning blog post series, structuring tutorial content

#### `git-workflow`
**Expert patterns for Git: branching, commits, collaboration**

Use when: Working with gh-pages branch, creating PRs, managing releases

#### `github-actions-creator`
**Create and manage GitHub Actions workflows**

Use when: Automating Jekyll builds, CI/CD for the blog

---

## OpenSpec Skills (Primary Workflow)

All skills follow the same conceptual pattern:

### 🎯 Primary Skills

#### `openspec-new-change`
**Start a new change with the artifact-driven workflow**

Use when: Creating a new feature, fix, or significant modification

Flow:
1. Optionally provide a change name (kebab-case) or describe what you want to build
2. System infers the schema (defaults to spec-driven)
3. Agent creates scaffolding at `openspec/changes/<name>/`
4. Agent shows first artifact template and stops for your input

#### `openspec-apply-change`
**Implement tasks from an existing change**

Use when: You have an active change and need to implement the work

#### `openspec-continue-change`
**Create the next artifact in a change**

Use when: Current artifact(s) complete but design incomplete

#### `openspec-explore`
**Think through ideas before or during a change**

Use when: You need to explore/investigate before committing to a design

#### `openspec-verify-change`
**Validate implementation matches artifacts**

Use when: Want to ensure implementation is complete and coherent before archiving

---

## Ruby & Jekyll Development Standards

### Core Principles

- Use `bundle exec` prefix for all Jekyll/gem commands
- Pin Ruby version via `.ruby-version`
- Keep `Gemfile` locked (`Gemfile.lock`)
- Follow Jekyll conventions for front matter, layouts, and includes

### Project Structure

```
.
├── _posts/                   # Blog posts (YYYY-MM-DD-title.md)
├── _layouts/                 # Page templates
├── _includes/                # Reusable components
├── _site/                    # Built site (git-ignored, generated)
├── assets/                   # CSS, JS, images
├── common/bin/
│   ├── ruby.mk              # Ruby/Bundler Makefile helpers
│   └── jekyll.mk            # Jekyll/gh-pages Makefile helpers
├── .agents/                  # Agent skills and workflow resources
├── Gemfile                   # Ruby dependencies
├── _config.yml               # Jekyll configuration
├── .ruby-version             # Ruby version pinning
├── AGENTS.md                 # This file — agent workflow guide
└── README.md                 # Project overview
```

### Git Workflow

This project uses a two-branch model:
- **`main`** — Development: source files, Makefiles, configuration, agent resources
- **`gh-pages`** — Published: Jekyll-built HTML deployed to GitHub Pages

Blog posts are written on `gh-pages` (or a feature branch off it) and deployed via `make deploy-gh-pages`.

#### Quick Reference: Branch Workflow for Blog Posts

```bash
# Start from gh-pages
git checkout gh-pages && git pull
git checkout -b post/my-new-post-title

# Create the post
make new-post title="My New Post Title"
# Edit _posts/YYYY-MM-DD-my-new-post-title.md

# Preview locally
make jekyll-serve

# Commit and deploy
git add _posts/
git commit -m "feat(post): add 'My New Post Title'"
git checkout gh-pages
git merge post/my-new-post-title
make deploy-gh-pages
```

#### Conventional Commits for Blog

```
feat(post): add new blog post on <topic>
fix(post): correct typo in <post-slug>
style(site): update CSS for <element>
chore(deps): bump jekyll to <version>
docs(readme): update project overview
```

---

## Extended Skills Reference

### `git-workflow` 🔗 Git Workflow Skill

**Expert patterns for Git version control: branching, commits, collaboration, and CI/CD.**

#### Quick Reference: Branch Naming
```bash
post/YYYY-MM-DD-post-title     # New blog posts
fix/post-slug-correction       # Post fixes
feature/site-feature-name      # Site features
release/1.2.0                  # Release branches
```

---

## Directory Reference

**Agent Resources (Deployed):**
- `~/.agents/skills/` — All OpenSpec and domain-specific skills
- `~/.agents/commands/` — CLI command definitions
- `~/.agents/prompts/` — Prompt templates for agent workflows
- `~/.agents/settings.json` — Agent configuration and integration settings

**Agent Resources (Development):**
- `.agents/skills/` — All OpenSpec and domain-specific skills
- `.agents/commands/` — CLI command definitions
- `.agents/prompts/` — Prompt templates for agent workflows
- `.agents/settings.json` — Agent configuration and integration settings

**Project Configuration:**
- `openspec/config.yaml` — Schema and project context
- `openspec/changes/` — Active and archived changes
- `openspec/specs/` — Specification files for the project

**Deployment:**
- Copy entire `.agents/` directory from project to `~/.agents/` for system-wide home-based access
- Agents automatically locate resources in `~/.agents/` on any system

---

**Last Updated:** 2026-02-27
