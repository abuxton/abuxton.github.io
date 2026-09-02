# Jekyll and gh-pages helper snippets for Makefiles.
# Usage examples:
#   make jekyll-build
#   make jekyll-serve JEKYLL_OPTS="--drafts"
#   make new-post title="My Title" slug="my-slug"
#   make new-post title="My Title" agent="GitHub Copilot" agent_url="https://github.com/features/copilot"
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
$(call using_ruby, \
  if command -v bundle >/dev/null 2>&1; then \
    bundle exec $(1); \
  else \
    $(1); \
  fi)
endef

# Build site (callable function): $(call jekyll_build_cmd, <extra-args>)
define jekyll_build_cmd
$(call with_bundle,jekyll build --config $(JEKYLL_CONFIG) $(JEKYLL_OPTS) $(1))
endef


define jekyll_serve_cmd
$(call with_bundle,jekyll serve --config $(JEKYLL_CONFIG) --livereload $(JEKYLL_OPTS) $(1))
endef

# Targets --------------------------------------------------------------------

.PHONY: jekyll-build jekyll-serve jekyll-clean jekyll-preview new-post jekyll-info

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
# make new-post title="My Title" [slug="my-slug"] [layout="post"] [agent="Agent"] [agent_url="https://..."]
new-post: ## Create a post. AI co-authors require agent and agent_url.
	@if [ -z "$(title)" ]; then \
	  echo "Usage: make new-post title=\"My Title\" [slug=\"my-slug\"] [layout=\"post\"] [agent=\"Agent\" agent_url=\"https://...\"]"; \
	  exit 1; \
	fi
	@layout=$${layout:-post}; \
    @if { [ -n "$(agent)" ] && [ -z "$(agent_url)" ]; } || { [ -z "$(agent)" ] && [ -n "$(agent_url)" ]; }; then \
	  echo "AI co-authors require both agent and agent_url."; \
	  exit 1; \
	fi
	slug=$$([ -n "$(slug)" ] && echo "$(slug)" || echo "$(title)" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$$//g'); \
	date=$$(date "+%Y-%m-%d"); \
	filename="_posts/$$date-$$slug.md"; \
	mkdir -p "_posts"; \
	if [ -e "$$filename" ]; then \
	  echo "Post exists: $$filename"; \
	else \
	  { echo "---"; echo "layout: $$layout"; echo "title: \"$(title)\""; echo "date: $$(date -u +"%Y-%m-%d %H:%M:%S %z")"; echo "categories: [blog]"; echo "tags: []"; echo "---"; echo ""; if [ -n "$(agent)" ]; then echo "> 🤖 **AI co-author:** [$(agent)]($(agent_url))"; echo ""; fi; } > "$$filename"; \
	  echo "Created $$filename"; \
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
