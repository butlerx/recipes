SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# OS and architecture detection
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
	HUGO_OS := darwin-universal
	DOWNLOAD_OS := darwin-universal # universal recommended for Apple/intel
else
	HUGO_OS := Linux-64bit
	DOWNLOAD_OS := Linux-64bit
endif

DESTDIR := public
HUGO_VERSION := 0.104.2
HUGO := .cache/hugo_$(HUGO_VERSION)_$(HUGO_OS)
BINS = $(HUGO)

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

# Download hugo binary for apple (darwin) or linux. Try wget, or fallback to curl.
$(HUGO):
	@echo "🤵 Getting Hugo ($(HUGO_OS))"
	mkdir -p tmp/
	$(if $(shell command -v wget 2>/dev/null), \
		wget -q -P tmp/ https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(DOWNLOAD_OS).tar.gz, \
		curl -fsSL -o tmp/hugo_extended_$(HUGO_VERSION)_$(DOWNLOAD_OS).tar.gz https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(DOWNLOAD_OS).tar.gz)
	tar xf tmp/hugo_extended_$(HUGO_VERSION)_$(DOWNLOAD_OS).tar.gz -C tmp/
	mkdir -p .cache
	mv -f tmp/hugo .cache/hugo_$(HUGO_VERSION)_$(HUGO_OS)
	rm -rf tmp/

.PHONY: help
help: ## Display this help screen and platform info
	@echo "Building on platform: $(UNAME_S) ($(HUGO_OS)), arch: $(UNAME_M)"
	@echo "Hugo version: $(HUGO_VERSION)"
	@echo "\nSupported on Linux and macOS (Apple Silicon and Intel Universal)."
	@echo "If mogrify is missing, install via 'brew install imagemagick' (macOS) or 'sudo apt install imagemagick' (Linux)."
	@echo "If wget is missing, install via 'brew install wget' or 'sudo apt install wget', or ensure curl is available."
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
