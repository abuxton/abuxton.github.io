# abuxton.github.io

The home for [abuxton.github.io](http://abuxton.github.io)

## Overview

This is a Jekyll-based static site hosted on GitHub Pages. The repository contains source files, Makefiles, and build configuration across multiple branches:

- **`main`** – Development branch; source, Makefiles, Jekyll configuration
- **`gh-pages`** – Published site (deployed via `make deploy-gh-pages`)
- **`archive`** – Historical/archived site versions (optional backup)

## Quick Start

### Prerequisites

- Ruby (see `.ruby-version`)
- Bundler
- GNU Make

### Setup

```bash
git clone https://github.com/abuxton/abuxton.github.io.git
cd abuxton.github.io
git co -b feature/my-ghpages gh-pages
make bundle-install
```

### Local Development

Serve the site locally with livereload:

```bash
make jekyll-serve
```

Browse to `http://localhost:4000`

## Common Tasks

| Task | Command | Notes |
|------|---------|-------|
| Serve locally | `make jekyll-serve` | Livereload enabled |
| Build site | `make jekyll-build` | Output to `_site/` |
| Clean build | `make jekyll-clean` | Remove `_site/` |
| New post | `make new-post title="My Title"` | Scaffolds `_posts/` file |
| Deploy | `make deploy-gh-pages` | Build + push to gh-pages |
| Show help | `make help-ruby` | Ruby/Bundler targets |

## Project Structure

```
.
├── _posts/                   # Blog posts
├── _layouts/                 # Page templates
├── _includes/                # Reusable components
├── _site/                    # Built site (generated)
├── assets/                   # CSS, JS, images
├── common/bin/
│   ├── ruby.mk              # Ruby/Bundler Makefile helpers
│   └── jekyll.mk            # Jekyll/gh-pages Makefile helpers
├── Gemfile                   # Ruby dependencies
├── _config.yml               # Jekyll configuration
├── .ruby-version             # Ruby version pinning
└── README.md                 # This file
```

## Deployment

Deploy to GitHub Pages:

```bash
make deploy-gh-pages
```

This:
1. Builds the Jekyll site
2. Pushes built content to the `gh-pages` branch
3. Site goes live at [abuxton.github.io](http://abuxton.github.io)

## Ruby & Bundler

All commands run through the active Ruby environment (rbenv or rvm if available):

```bash
make ruby-info              # Show Ruby/Bundler versions
make bundle-install         # Install Gemfile dependencies
make run-rake TASK="foo"     # Run rake task
make gem-install GEM="name"  # Install a gem
```

## License

[Add license]

