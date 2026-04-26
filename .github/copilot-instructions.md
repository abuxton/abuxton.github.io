# Copilot Instructions

## Project Overview

This is a Jekyll-based personal blog hosted on GitHub Pages at `blog.abcdevelopment.co.uk`. It uses the **Chirpy** theme (`cotes2020/jekyll-theme-chirpy` v7.x) and is deployed via GitHub Actions (`/.github/workflows/pages-deploy.yml`) — not via the `github-pages` gem, because Chirpy is not on the GitHub Pages safe-list.

The project is structured with a Makefile for task automation, and Ruby gems are managed via Bundler. Blog content lives in `_posts/`, navigation tabs in `_tabs/`.

## Instructions

- For any code changes, follow the **Plan → Tasks → Implementation** workflow outlined in `AGENTS.md`.
- Use the Makefile for all build, serve, and maintenance tasks. Refer to `AGENTS.md` for available commands and their usage.
- When creating new posts, use the `make new-post` target to scaffold the file with correct front matter.
- Adhere to the post front matter convention below for consistency across blog entries.

## Build & Serve Commands

All common tasks are managed via `make`. Run `make` (or `make help`) to see all available targets.

```sh
# Install Ruby gems
make bundle-install

# Build the static site into _site/
make jekyll-build

# Serve locally with livereload at http://localhost:4000
make jekyll-serve

# Pass extra Jekyll flags (e.g. render draft posts)
make jekyll-serve JEKYLL_OPTS="--drafts"

# Clean the built site
make jekyll-clean

# Print Ruby/Bundler environment info
make ruby-info
```

Always use `bundle exec` (or `make` targets) rather than calling `jekyll` directly — the Makefile handles this automatically via `with_bundle`.

Ruby version is pinned to **3.3.7** in `.ruby-version`. The Makefile auto-detects `rbenv` or `rvm` and activates the correct version.

## Creating New Posts

```sh
make new-post title="My Post Title"
# With an explicit slug:
make new-post title="My Post Title" slug="my-post-slug"
```

This scaffolds a file in `_posts/YYYY-MM-DD-slug.md` with the correct front matter.

## Architecture

- `_config.yml` — site-wide settings (title, Chirpy options, plugins, etc.)
- `_posts/` — blog posts as Markdown with Jekyll front matter
- `_tabs/` — Chirpy navigation tab pages: `about.md`, `archives.md`, `categories.md`, `tags.md`
- `404.html` — custom 404 page
- `CNAME` — sets the custom domain for GitHub Pages
- `common/` — shared Makefile library (not site content):
  - `common/mk/core.mk` — entry point; includes the three mk modules below
  - `common/bin/jekyll.mk` — Jekyll-specific targets
  - `common/bin/ruby.mk` — Ruby/Bundler helpers and callable `make` functions
  - `common/bin/git.mk` — Git/GitHub CLI helpers
- `Makefile` at repo root includes `common/mk/core.mk` to expose all targets
- `.github/workflows/pages-deploy.yml` — GitHub Actions workflow that builds and deploys the site
- `skills-lock.json` — locks Claude/agent skill versions; do not edit manually

## Post Front Matter Convention

```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +0000
categories: [main-category, sub-category]   # max 2 levels for Chirpy
tags: [tag1, tag2, tag3]
---
```

Use `layout: post` for blog entries. Chirpy renders `categories` as a breadcrumb (max 2 recommended) and `tags` as clickable taxonomy links. Both must be YAML arrays.

