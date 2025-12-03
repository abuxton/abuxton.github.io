# Ruby helper snippets for Makefiles.
# Usage examples:
#   $(call with_rbenv, ruby -v)
#   $(call bundle_install)
#   $(call run_rake,db:migrate)

-include .env
REPO_TOP=$(shell git rev-parse --show-toplevel)
CORE=${REPO_TOP}/common/mk/core.mk
BIN_DIR=${REPO_TOP}/common/bin

# Detect helpers
RBENV := $(shell command -v rbenv 2>/dev/null || true)
RVM := $(shell command -v rvm 2>/dev/null || true)
GEM := $(shell command -v gem 2>/dev/null || true)
BUNDLE := $(shell command -v bundle 2>/dev/null || true)

RUBY_VERSION_FILE := .ruby-version
RUBY_VERSION := $(strip $(shell test -f $(RUBY_VERSION_FILE) && cat $(RUBY_VERSION_FILE) || echo ""))

# Functions -----------------------------------------------------------------
# Use with $(call name, args...)
#
# Examples:
#   $(call with_rbenv, ruby -v)
#   $(call using_ruby, gem list)
#   $(call bundle_install)
#   $(call run_rake,db:migrate)

define with_rbenv
if command -v rbenv >/dev/null 2>&1; then \
  export RBENV_SHELL=bash; \
  eval "$$(rbenv init -)"; \
fi; \
$(1)
endef

define with_rvm
if command -v rvm >/dev/null 2>&1; then \
  source "$$HOME/.rvm/scripts/rvm" >/dev/null 2>&1 || true; \
  if [ -n "$(RUBY_VERSION)" ]; then rvm use $(RUBY_VERSION) >/dev/null 2>&1 || true; fi; \
fi; \
$(1)
endef

define using_ruby
if command -v rbenv >/dev/null 2>&1; then \
  $(call with_rbenv,$(1)); \
elif command -v rvm >/dev/null 2>&1; then \
  $(call with_rvm,$(1)); \
else \
  $(1); \
fi
endef

define ensure_bundler
$(call using_ruby, \
  if ! command -v bundle >/dev/null 2>&1; then \
	echo "Installing bundler..."; \
	gem install bundler --no-document; \
  fi)
endef

define bundle_install
$(call using_ruby, \
  $(call ensure_bundler); \
  if [ -f Gemfile ]; then \
	bundle check >/dev/null 2>&1 || bundle install --jobs=4 --retry=3; \
  fi)
endef

define run_rake
$(call using_ruby, \
  $(call bundle_install); \
  if command -v bundle >/dev/null 2>&1; then bundle exec rake $(1); else rake $(1); fi)
endef

define run_rubocop
$(call using_ruby, \
  if ! command -v rubocop >/dev/null 2>&1; then \
	gem install rubocop --no-document; \
  fi; \
  rubocop $(1))
endef

define gem_install
$(call using_ruby, \
  if ! gem list -i $(1) >/dev/null 2>&1; then \
	gem install $(1) --no-document; \
  fi)
endef

# Convenience phony targets -------------------------------------------------

.PHONY: ruby-info bundle-install run-rake run-rubocop gem-install help-ruby

ruby-info:  ## Print ruby / bundler info
	@$(call using_ruby,ruby -v; gem env; echo "GEM: $$(command -v gem || true)"; echo "BUNDLE: $$(command -v bundle || true)")

bundle-install:  ## Install gems from Gemfile (uses bundler if present)
	@$(call bundle_install)

# run-rake TASK="db:migrate"
run-rake:  ## Run a rake task. Usage: make run-rake TASK="task:name"
	@if [ -z "$(TASK)" ]; then echo "Usage: make run-rake TASK=\"task:name\""; exit 1; fi
	@$(call run_rake,$(TASK))

# run-rubocop PATHS="lib spec"
run-rubocop:  ## Run rubocop. Usage: make run-rubocop PATHS="lib spec"
	@$(call run_rubocop,$(PATHS))

# gem-install GEM="rake -v 13.0"
gem-install:  ## Install a gem using the active ruby. Usage: make gem-install GEM="rake -v 13.0"
	@if [ -z "$(GEM)" ]; then echo "Usage: make gem-install GEM=\"name [version]\""; exit 1; fi
	@$(call gem_install,$(GEM))

.PHONY: help-ruby
help-ruby:  ## Show help messages for make targets in ${BIN_DIR}/ruby.mk
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(BIN_DIR)/ruby.mk) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
