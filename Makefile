SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DESTDIR := public
HUGO_VERSION := 0.104.2
HUGO := .cache/hugo_$(HUGO_VERSION)
SASS_VERSION := 1.55.0
SASS := .cache/dart-sass-embedded_$(SASS_VERSION)
PLATFORM := Linux-64bit

export PATH := $(PATH):$(PWD)/$(SASS)
BINS = $(HUGO) $(SASS)

.PHONY: build
build: public  ## Build Site
public: $(BINS) config.toml content
	@echo "🍳 Generating site"
	$< --gc --minify -d $(DESTDIR)
	echo "🧂 Optimizing images"
	find $@ -not -path "*/static/*" \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) -print0 | xargs -0 -P8 -n2 mogrify -strip -thumbnail '1000>'

.PHONY: update
update: $(BINS) ## Update themes and binaries
	@echo "🛎 Updating Theme"
	$(HUGO) mod get -u ./...
	$(HUGO) mod tidy

.PHONY: serve
serve: $(BINS) ## Run development server in debug mode
	@HUGO_MODULE_REPLACEMENTS="github.com/butlerx/hugo-recipes -> ../../hugo-recipes" \
		$(HUGO) server -D -w

.PHONY: clean
clean: ## Clean built site
	@echo "🧹 Cleaning old build"
	rm -rf public resources .cache

.PHONY: lint format
format: ## Format Markdown files
	@prettier --write .

lint: format ## Run markdown linter
	@echo "🍜 Testing Markdown"
	@docker run -v $(PWD):/workdir ghcr.io/igorshubovych/markdownlint-cli:latest "content"

$(HUGO):
	@echo "🤵 Getting Hugo"
	wget -q -P tmp/ https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(PLATFORM).tar.gz
	tar xf tmp/hugo_extended_$(HUGO_VERSION)_$(PLATFORM).tar.gz -C tmp/
	mkdir -p .cache
	mv -f tmp/hugo $(HUGO)
	rm -rf tmp/

$(SASS):  ## Install dependencies for sass
	@echo "🤵 Getting embedded sass"
	wget -q -P tmp/ https://github.com/sass/dart-sass-embedded/releases/download/$(SASS_VERSION)/sass_embedded-$(SASS_VERSION)-linux-x64.tar.gz
	mkdir -p  $@
	tar xf tmp/sass_embedded-$(SASS_VERSION)-linux-x64.tar.gz -C tmp/
	mv -f tmp/sass_embedded/dart-sass-embedded $@
	rm -rf tmp/

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
