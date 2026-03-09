# Agent Workflow Guide for abuxton.github.io

This is a Jekyll-based personal blog hosted on GitHub Pages at `blog.abcdevelopment.co.uk`. This guide explains how to work with agents on this project using a simple **Plan → Tasks → Implementation** workflow. Use this regardless of which agent interface you're using (GitHub Copilot, Claude, OpenCode, or any other agent).

## Project Context

**Technology Stack:**
- Jekyll static site generator
- Minima theme
- GitHub Pages hosting
- Ruby 3.3.7 (pinned in `.ruby-version`)
- Makefile-based task automation

**Key Commands:**
```bash
make                           # Show all available targets
make bundle-install           # Install Ruby gems
make jekyll-build             # Build static site
make jekyll-serve             # Serve locally with livereload
make jekyll-serve JEKYLL_OPTS="--drafts"  # Include draft posts
make jekyll-clean             # Clean build
make new-post title="Title"   # Create new post
```

**Project Structure:**
- `_config.yml` — Site configuration (title, baseurl, theme, plugins)
- `_posts/` — Blog posts with Jekyll front matter
- `index.markdown` — Home page
- `about.markdown` — About page
- `common/` — Shared Makefile utilities (not site content)
- `CNAME` — Custom domain configuration

## Workflow Approach

Work on this project follows a simple **Plan → Tasks → Implementation** pattern:

1. **Plan** — Clarify what you're building, why, and acceptance criteria
2. **Tasks** — Break work into concrete, actionable items
3. **Implementation** — Execute tasks and make code changes
4. **Validation** — Verify work is complete and correct
5. **Integration** — Commit and deploy via Git/GitHub Pages

This approach is lightweight, practical, and integrates seamlessly with Jekyll and Git workflows.

## Available Skills

This repository includes specialized skills for various tasks. Skills are available in `.agents/skills/` during development and can be deployed to `~/.agents/skills/` for system-wide access.

### 💬 Content & Documentation Skills

#### `brainstorming`
Expand seeds and escape convergent ideation. Use when you have the start of an idea and want to grow it, when brainstorming produces the same ideas every time, or when you need to explore possibility space.

#### `doc-coauthoring`
Guide users through a structured workflow for co-authoring documentation. Use when writing documentation, proposals, technical specs, decision docs, or similar structured content.

#### `markdown-documentation`
Master markdown formatting, GitHub Flavored Markdown, README files, and documentation formatting. Use when writing markdown docs, READMEs, or formatting documentation.

#### `outline-coach`
Act as an assistive outline coach who guides structural development through questions. Use when developing your own outline through diagnosis and frameworks.

#### `outline-collaborator`
Act as an active outline partner who develops structure collaboratively. Use when developing, iterating, or improving story outlines, generating scene beats and character arcs.

#### `summarization`
Create effective summaries by matching summarization type to purpose, audience, and context. Use when asked to summarize, create TLDR, condense content, or create executive summaries.

#### `writing-clearly-and-concisely`
Use when writing prose humans will read—documentation, commit messages, error messages, explanations, reports, or UI text. Applies timeless rules for clearer, stronger, more professional writing.

### 📊 Document Generation Skills

#### `docx`
Create, read, edit, or manipulate Word documents (.docx files). Use when producing professional documents with formatting like tables of contents, headings, page numbers, or letterheads.

#### `pdf`
Read or extract text/tables from PDFs, combine or merge multiple PDFs, split PDFs, add watermarks, create new PDFs, fill PDF forms, encrypt/decrypt, extract images, or perform OCR on scanned PDFs.

#### `pptx`
Create slide decks, pitch decks, or presentations; read, parse, or extract text from .pptx files; edit or modify existing presentations; combine or split slide files; work with templates, layouts, speaker notes.

#### `revealjs-presenter`
Generate RevealJS HTML presentations with reliable layout, professional typography, and effective visual communication. Use when creating slide decks, pitch presentations, or technical talks.

#### `frontend-slides`
Create stunning, animation-rich HTML presentations from scratch or by converting PowerPoint files. Use when building a presentation or converting PPT/PPTX to web.

#### `xlsx`
Open, read, edit, or fix existing .xlsx, .xlsm, .csv, or .tsv files; create new spreadsheets from scratch; convert between tabular file formats. Use when the spreadsheet is the primary input or output.

### 🛠️ Workflow & Process Skills

#### `git-workflow`
Expert patterns for Git version control: branching strategies (Git Flow, GitHub Flow, Trunk-based), Conventional Commits, pull requests, merge conflicts, CI/CD integration, and advanced operations (rebase, cherry-pick, bisect).

**Quick Reference:**
- Use `feature/description` for features, `fix/description` for fixes, `release/1.0.0` for releases
- Conventional Commits format: `<type>[scope]: <description>` (types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`)
- Merge PRs with: `git add -p` → `git commit -m "..."` → `git push` → `gh pr create` → `gh pr merge --squash`

#### `skill-creator`
Create new skills, modify and improve existing skills, and measure skill performance. Use when wanting to create a skill from scratch, edit an existing skill, or optimize a skill's description.

#### `skill-integrator`
Integrate installed skill usage guidance into project documentation. Use when skills are installed but agents don't know when to use them, or when updating guidance after adding skills.

#### `user-story-writing`
Write effective user stories that capture requirements from the user's perspective. Create clear stories with detailed acceptance criteria to guide development.

#### `technology-impact`
Systematically analyze societal impacts of technologies using McLuhan's Tetrad of Media Effects. Use when evaluating new technology, planning technology adoption, or analyzing technology policy.

### 🚀 Quick Reference

**Typical Workflow:**
1. **Clarify** — What are you building? Use `brainstorming` if uncertain
2. **Plan** — Create a task list for implementation
3. **Implement** — Make changes, use `git-workflow` for commits
4. **Document** — Write markdown (use `markdown-documentation`) or create slides (use `pptx` or `revealjs-presenter`)
5. **Validate** — Run `make jekyll-serve` to test locally
6. **Commit** — Use Conventional Commits with `git-workflow`

**Examples:**
- **New blog post:** `make new-post title="My Post"` → Write markdown → `make jekyll-serve` → Test → Commit
- **Site documentation:** Use `doc-coauthoring` to plan → `markdown-documentation` to write → Commit
- **Presentation:** Use `pptx` or `revealjs-presenter` to create → Export → Deploy

## Important: Temporary Working Directory

### ⚠️ CRITICAL: Use `./tmp` for ALL temporary files, NEVER `/tmp`

**This is a mandatory requirement for all agent workflows. ALWAYS follow this rule:**

**DO THIS:**
```bash
# Create working files in project-local ./tmp directory
echo "data" > ./tmp/workfile.txt
./some-script.sh > ./tmp/output.log
cp large_file.bin ./tmp/backup.bin
```

**NEVER DO THIS:**
```bash
# WRONG - never use system /tmp
echo "data" > /tmp/workfile.txt        # ❌ INCORRECT
cd /tmp && ./script.sh                  # ❌ INCORRECT
cp data /tmp/backup.txt                 # ❌ INCORRECT
```

**Why this is mandatory:**
- ✅ All working files stay local to the repository
- ✅ Easier cleanup and resetting of agent state
- ✅ Better isolation between concurrent processes
- ✅ No pollution of system directories
- ✅ Files persist for debugging and review
- ✅ Portable across different machines and environments

**Key Points:**
- The `.gitignore` file already excludes `./tmp/`
- Agents creating intermediate files MUST use `./tmp`
- Scripts and commands MUST write working output to `./tmp`
- When creating a `./tmp` file, verify it doesn't exist first
- Always reference `./tmp` relative to the project root
- Delete contents of `./tmp` only when explicitly requested by user

This rule is non-negotiable and applies to every task.
