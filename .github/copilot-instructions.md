# Copilot Instructions for abuxton.github.io

**PRIMARY RESOURCE:** Before consulting this file, refer to `AGENTS.md` in the root of this repository for the authoritative workflow and skill reference.

This document provides GitHub Copilot guidance for working on this Ruby/Jekyll blog project.

---

## Project Overview

This is a Jekyll-based blog published at [http://blog.abcdevelopment.co.uk](http://blog.abcdevelopment.co.uk).

- **Language:** Ruby
- **Framework:** Jekyll (static site generator)
- **Hosting:** GitHub Pages
- **Blog branch:** `gh-pages` — published content
- **Dev branch:** `main` — source, configuration, agent resources

---

## Key References

- **[AGENTS.md](../AGENTS.md)** — Primary agent workflow guide, Jekyll conventions, OpenSpec skills
- **[README.md](../README.md)** — Project setup and common tasks
- **[.agents/skills/](../.agents/skills/)** — Available agent skills (jekyll-blog, git-workflow, writing, etc.)
- **[.agents/prompts/](../.agents/prompts/)** — OpenSpec workflow prompts

---

## When Working on This Project

### Blog Posts

1. Posts live in `_posts/` on `gh-pages` branch
2. Naming convention: `YYYY-MM-DD-title-slug.md`
3. Always include Jekyll front matter (layout, title, date, categories, tags)
4. Use `make new-post title="Post Title"` to scaffold
5. Preview with `make jekyll-serve` before deploying
6. Deploy with `make deploy-gh-pages`

### Ruby/Jekyll Standards

- Always use `bundle exec` prefix for Ruby/Jekyll commands
- Keep `Gemfile.lock` committed
- Follow Jekyll directory conventions (`_posts/`, `_layouts/`, `_includes/`, `assets/`)
- Use `.ruby-version` for Ruby version pinning

### Git Conventions

- Conventional commits: `feat(post):`, `fix(post):`, `chore(deps):`, `docs:`
- Branch naming: `post/YYYY-MM-DD-title` for blog posts, `feature/` for site features
- PRs target `gh-pages` for content, `main` for site/tooling changes

### Agent Workflow (OpenSpec)

When making significant changes, use the OpenSpec workflow:

```bash
# Explore an idea
@workspace Use skill openspec-explore to think through <idea>

# Start a new change
@workspace Use skill openspec-new-change for <change-description>

# Continue working through artifacts
@workspace Use skill openspec-continue-change for <change-name>

# Implement the work
@workspace Use skill openspec-apply-change for <change-name>
```

All OpenSpec commands are in `.agents/commands/opsx/`.
All prompts are in `.agents/prompts/`.
All skills are in `.agents/skills/`.

---

## Available Skills Summary

| Skill | Purpose |
|-------|---------|
| `jekyll-blog` | Jekyll post creation, site management, gh-pages deployment |
| `writing-clearly-and-concisely` | Clear, engaging technical writing |
| `markdown-documentation` | Markdown formatting best practices |
| `user-story-writing` | Structured story/content planning |
| `git-workflow` | Git branching, commits, PRs |
| `github-actions-creator` | CI/CD automation workflows |
| `skill-creator` | Create new agent skills |

See `.agents/skills/` for the complete list.

---

**Date:** 2026-02-27
