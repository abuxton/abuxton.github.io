# Jekyll Blog Skill

**Purpose:** Expert guidance for working with Jekyll static site projects, blog post creation, site configuration, and GitHub Pages deployment.

**Use when:**
- Creating or editing blog posts in Jekyll format
- Managing site configuration (`_config.yml`)
- Working with Jekyll layouts, includes, and assets
- Deploying to GitHub Pages via `gh-pages` branch
- Setting up or troubleshooting Ruby/Bundler for Jekyll
- Writing Liquid templates or Jekyll plugins

---

## Jekyll Blog Fundamentals

### Post File Naming

All posts must follow this convention:

```
_posts/YYYY-MM-DD-title-slug.md
```

Examples:
```
_posts/2025-12-01-welcome-back.md
_posts/2026-01-15-building-github-profile.md
_posts/2026-02-10-dotfiles-development.md
```

### Required Front Matter

Every post must begin with YAML front matter:

```yaml
---
layout: post
title: "Your Post Title Here"
date: 2026-01-15 12:00:00 +0000
categories: [category]
tags: [tag1, tag2]
---
```

### Front Matter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `layout` | Yes | Template to use (`post`, `page`, `default`) |
| `title` | Yes | Display title of the post |
| `date` | Yes | Publication date and time with timezone |
| `categories` | Recommended | Array of categories for organization |
| `tags` | Optional | Array of tags for fine-grained classification |
| `excerpt` | Optional | Custom excerpt for listing pages |
| `author` | Optional | Post author (if multiple authors) |

---

## Common Tasks

### Create a New Post

```bash
# Using the project Makefile
make new-post title="My New Post Title"

# Or create manually
touch _posts/$(date +%Y-%m-%d)-my-new-post-title.md
```

### Local Development

```bash
# Install dependencies
make bundle-install
# or: bundle install

# Serve with live reload
make jekyll-serve
# or: bundle exec jekyll serve --livereload

# Build only
make jekyll-build
# or: bundle exec jekyll build

# Clean build artifacts
make jekyll-clean
# or: rm -rf _site
```

### Deploy to GitHub Pages

```bash
# Full deploy (build + push to gh-pages)
make deploy-gh-pages

# Manual approach
bundle exec jekyll build
# Then push _site/ contents to gh-pages branch
```

---

## Jekyll Configuration (`_config.yml`)

Key configuration options for this blog:

```yaml
# Site settings
title: "Blog Title"
description: "Site description"
url: "http://blog.abcdevelopment.co.uk"
baseurl: ""

# Build settings
markdown: kramdown
highlighter: rouge
theme: minima  # or your chosen theme

# Plugins
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap

# Defaults
defaults:
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
      author: "abuxton"
```

---

## Directory Structure

```
.
├── _posts/               # Blog post Markdown files
├── _drafts/              # Unpublished draft posts
├── _layouts/             # Page templates (post.html, page.html, default.html)
├── _includes/            # Reusable HTML fragments (header, footer, nav)
├── _data/                # YAML/JSON data files
├── _site/                # Generated site (git-ignored)
├── assets/
│   ├── css/              # Stylesheets
│   ├── js/               # JavaScript
│   └── images/           # Post images and media
├── _config.yml           # Jekyll configuration
├── Gemfile               # Ruby dependencies
├── Gemfile.lock          # Locked dependency versions
├── .ruby-version         # Ruby version pin
└── index.html            # Home page
```

---

## Writing Blog Posts: Best Practices

### Post Structure

```markdown
---
layout: post
title: "Descriptive, Engaging Title"
date: 2026-01-15 12:00:00 +0000
categories: [development]
tags: [github, ruby, jekyll]
---

Opening paragraph that hooks the reader and summarizes what the post covers.

## Background

Context and motivation for this post.

## Main Content

The core of your post with clear sections.

### Subsection

Detail and examples.

```ruby
# Code example with syntax highlighting
def hello_world
  puts "Hello, World!"
end
```

## Conclusion

Summary of key points and next steps.
```

### Style Guidelines

- **Title:** Clear and descriptive, front-load key terms
- **Opening:** Hook the reader in the first paragraph
- **Headings:** Use `##` for main sections, `###` for subsections
- **Code:** Always specify language for syntax highlighting
- **Images:** Use relative paths (`/assets/images/post-image.png`)
- **Links:** Use descriptive anchor text, not "click here"
- **Length:** Aim for complete coverage without padding

### Categories for This Blog

| Category | Usage |
|----------|-------|
| `update` | Site/project announcements and updates |
| `development` | Software development topics |
| `github` | GitHub features, workflows, profile |
| `ai` | AI tools, Copilot, agent skills |
| `ruby` | Ruby language and ecosystem |
| `jekyll` | Jekyll/static site topics |
| `dotfiles` | Dotfiles and development environment |

---

## Liquid Templates

Common Liquid syntax used in Jekyll:

```liquid
<!-- Loop through posts -->
{% for post in site.posts %}
  <a href="{{ post.url }}">{{ post.title }}</a>
{% endfor %}

<!-- Include a partial -->
{% include header.html %}

<!-- Site variables -->
{{ site.title }}
{{ site.description }}

<!-- Post variables -->
{{ page.title }}
{{ page.date | date: "%B %d, %Y" }}
{{ page.categories | join: ", " }}
{{ content }}
```

---

## GitHub Pages Deployment

This project uses the `gh-pages` branch for deployment:

```bash
# Workflow
git checkout gh-pages
git pull origin gh-pages
# ... make changes to posts/config ...
git add .
git commit -m "feat(post): add new post on <topic>"
make deploy-gh-pages
```

### Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Source: Makefiles, agent config, development tooling |
| `gh-pages` | Published: Jekyll source + `_site/` build artifacts |

---

## Gemfile for Jekyll

Typical `Gemfile` for this project:

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "minima", "~> 2.5"  # or your theme

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end

# Windows and JRuby compatibility
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
```

---

## Troubleshooting

### Common Issues

**Bundle install fails:**
```bash
gem install bundler
bundle install
```

**Jekyll serve port in use:**
```bash
bundle exec jekyll serve --port 4001
```

**Posts not showing:**
- Check date format in filename matches front matter
- Ensure `published: false` is not set
- Verify date is not in the future

**Build errors:**
```bash
bundle exec jekyll build --trace
```

**Liquid syntax errors:**
- Check for unclosed `{%` tags
- Validate YAML front matter with a YAML linter

---

## Related Skills

- `writing-clearly-and-concisely` — Content quality and clarity
- `markdown-documentation` — Markdown formatting
- `git-workflow` — Branch and commit conventions
- `github-actions-creator` — Automate builds and deployments
