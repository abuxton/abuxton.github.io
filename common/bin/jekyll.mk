# Jekyll and gh-pages helper snippets for Makefiles.
# Usage examples:
#   make jekyll-build
#   make jekyll-serve JEKYLL_OPTS="--drafts"
#   make new-post title="My Title" slug="my-slug"
#   make deploy-gh-pages
# https://github.com/krisnova/Makefile/blob/main/Makefile

-include .env
REPO_TOP=$(shell git rev-parse --show-toplevel)
CORE=${REPO_TOP}/common/mk/core.mk
BIN_DIR=${REPO_TOP}/common/bin

JEKYLL := $(shell command -v jekyll 2>/dev/null || true)
BUNDLE := $(shell command -v bundle 2>/dev/null || true)
JEKYLL_CONFIG ?= _config.yml
JEKYLL_OPTS ?=
SITE_DIR := _site

# Run a command under bundler if available (use: $(call with_bundle, <cmd>))
define with_bundle
if command -v bundle >/dev/null 2>&1; then \
  bundle exec $(1); \
else \
  $(1); \
fi
endef

# Build site (callable function): $(call jekyll_build_cmd, <extra-args>)
define jekyll_build_cmd
$(call with_bundle,jekyll build --config $(JEKYLL_CONFIG) $(JEKYLL_OPTS) $(1))
endef


define jekyll_serve_cmd
$(call with_bundle,jekyll serve --config $(JEKYLL_CONFIG) --livereload $(JEKYLL_OPTS) $(1))
endef

# Targets --------------------------------------------------------------------

.PHONY: jekyll-build jekyll-serve jekyll-clean jekyll-preview new-post deploy-gh-pages jekyll-info

jekyll-build: ## Build site (callable function): $(call jekyll_build_cmd, <extra-args>)
	@echo "Building Jekyll site..."
	@$(call jekyll_build_cmd)

jekyll-serve: ## Serve site with livereload (callable function): $(call jekyll_serve_cmd, <extra-args>)
	@echo "Serving Jekyll (livereload)..."
	@$(call jekyll_serve_cmd)

jekyll-clean: ## Clean built site
	@echo "Cleaning build dir: $(SITE_DIR)"
	@rm -rf "$(SITE_DIR)"

jekyll-preview: ## Preview built site in default browser
	@echo "Preview: open index in default browser"
	@open "$(SITE_DIR)/index.html" || true

# Create a new post:
# make new-post title="My Title" [slug="my-slug"] [layout="post"]
new-post: ## Create a new post. Usage: make new-post title="My Title" [slug="my-slug"] [layout="post"]
	@if [ -z "$(title)" ]; then echo "Usage: make new-post title=\"My Title\" [slug=\"my-slug\"] [layout=\"post\"]"; exit 1; fi
	@layout=${layout:-post}; \
	slug=$$( [ -n "$(slug)" ] && echo "$(slug)" || echo "$$(echo \"$(title)\" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$//g')"); \
	date=$$(date "+%Y-%m-%d"); \
	filename="_posts/$$date-$$slug.md"; \
	mkdir -p "_posts"; \
	if [ -e "$$filename" ]; then \
	  echo "Post exists: $$filename"; \
	else \
	  cat > "$$filename" <<EOF
	---
	layout: $$layout
	title: "$(title)"
	date: $$(date -u +"%Y-%m-%d %H:%M:%S %z")
	---
	EOF
	  echo "Created $$filename"; \
	fi

# Deploy to gh-pages branch. Two modes:
# - If gh-pages branch exists: use git worktree to replace its contents with _site and push.
# - If not: create an orphan gh-pages branch from _site and push.

deploy-gh-pages: ## Deploy built site to gh-pages branch
	jekyll-build
	@echo "Deploying to gh-pages..."
	@set -e; \
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then echo "Not a git repository"; exit 1; fi; \
	if git show-ref --verify --quiet refs/heads/gh-pages; then \
	  tmpdir=$$(mktemp -d); \
	  git worktree add --checkout --force "$$tmpdir" gh-pages; \
	  rsync -a --delete "$(SITE_DIR)/" "$$tmpdir"/; \
	  cd "$$tmpdir"; \
	  git add -A; \
	  if git diff --cached --quiet; then echo "No changes to deploy"; else git commit -m "Site rebuild: $$(date -u +'%Y-%m-%d %H:%M:%S UTC')"; git push origin gh-pages; fi; \
	  cd - >/dev/null; \
	  git worktree remove "$$tmpdir" >/dev/null 2>&1 || rm -rf "$$tmpdir"; \
	else \
	  echo "gh-pages branch does not exist: creating orphan branch and pushing"; \
	  git checkout --orphan gh-pages; \
	  git --work-tree="$(SITE_DIR)" add --all; \
	  git --work-tree="$(SITE_DIR)" commit -m "Initial gh-pages commit"; \
	  git push origin gh-pages; \
	  git checkout -f -; \
	  git branch -D gh-pages || true; \
	fi

jekyll-info: ## Show Jekyll environment info
	@echo "JEKYLL: $$(command -v jekyll || true)"; \
	echo "BUNDLE: $$(command -v bundle || true)"; \
	echo "JEKYLL_CONFIG: $(JEKYLL_CONFIG)"; \
	echo "JEKYLL_OPTS: $(JEKYLL_OPTS)"; \
	echo "SITE_DIR: $(SITE_DIR)"

# End -----------------------------------------------------------------------

.PHONY: help-jekyll
help-jekyll:  ## Show help messages for make targets in ${BIN_DIR}/jekyll.mk
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(BIN_DIR)/jekyll.mk) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
