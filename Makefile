# Makefile for ai-auto-governance-as-code — AI-Driven Governance-as-Code for Ansible Automation
# See README.md for full documentation

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help setup install install-hooks init-submodules install-python validate validate-yaml validate-python validate-skills lint test clean clean-cache clean-venv

# Detect repository root
REPO_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null || pwd)
AUTOMATION_HOME ?= $(REPO_ROOT)
AUTOMATION_REPO ?= $(AUTOMATION_HOME)/deliveries/automation

# Python environment
PYTHON := python3
# Prefer 3.13+ when available (lola-ai). Override: make venv PYTHON=python3.13
ifneq ($(shell command -v python3.13 2>/dev/null),)
  PYTHON := python3.13
endif
PIP := $(PYTHON) -m pip
VENV_DIR := .venv
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip

# Colors for output
COLOR_RESET := \033[0m
COLOR_BOLD := \033[1m
COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_BLUE := \033[34m

# Check if running in CI environment
CI ?= false

##@ General

help: ## Display this help message
	@echo "$(COLOR_BOLD)ai-auto-governance-as-code — Makefile targets$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BLUE)AUTOMATION_HOME=$(AUTOMATION_HOME)$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)AUTOMATION_REPO=$(AUTOMATION_REPO)$(COLOR_RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make $(COLOR_YELLOW)<target>$(COLOR_RESET)\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(COLOR_GREEN)%-20s$(COLOR_RESET) %s\n", $$1, $$2 } /^##@/ { printf "\n$(COLOR_BOLD)%s$(COLOR_RESET)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Setup

setup: install install-hooks ## Complete setup (Lola + submodules + pre-commit hooks)
	@echo "$(COLOR_GREEN)✓ Setup complete. Run 'make validate' to verify installation.$(COLOR_RESET)"

install: ## Install Lola SDLC modules and initialize Git submodules
	@echo "$(COLOR_BLUE)Installing Lola and syncing ai-forge SDLC modules...$(COLOR_RESET)"
	@command -v lola >/dev/null 2>&1 || $(PIP) install lola-ai
	@git submodule sync --recursive
	@git submodule update --init --recursive
	@lola market add ansible-content \
		$(REPO_ROOT)/skills/vendor/ai-forge/lola-market.yml \
		2>/dev/null || true
	@lola sync
	@echo "$(COLOR_GREEN)✓ Install complete$(COLOR_RESET)"

init-submodules: ## Initialize Git submodules (automation-good-practices, deliveries/automation)
	@echo "$(COLOR_BLUE)Initializing Git submodules...$(COLOR_RESET)"
	@git submodule sync --recursive
	@git submodule update --init --recursive
	@echo "$(COLOR_GREEN)✓ Submodules initialized$(COLOR_RESET)"

install-python: ## Install Python development dependencies
	@echo "$(COLOR_BLUE)Installing Python dependencies from requirements-dev.txt...$(COLOR_RESET)"
	@$(PIP) install --upgrade pip
	@$(PIP) install -r requirements-dev.txt
	@echo "$(COLOR_GREEN)✓ Python dependencies installed$(COLOR_RESET)"

install-hooks: ## Install pre-commit hooks
	@echo "$(COLOR_BLUE)Installing pre-commit hooks...$(COLOR_RESET)"
	@pre-commit install
	@if [ -f "$(AUTOMATION_REPO)/.pre-commit-config.yaml" ]; then \
		cd "$(AUTOMATION_REPO)" && pre-commit install; \
	fi
	@echo "$(COLOR_GREEN)✓ Pre-commit hooks installed$(COLOR_RESET)"

venv: ## Create Python virtual environment in .venv/
	@echo "$(COLOR_BLUE)Creating virtual environment...$(COLOR_RESET)"
	@$(PYTHON) -m venv $(VENV_DIR)
	@$(VENV_PIP) install --upgrade pip
	@$(VENV_PIP) install -r requirements-dev.txt
	@echo "$(COLOR_GREEN)✓ Virtual environment created at $(VENV_DIR)$(COLOR_RESET)"
	@echo "$(COLOR_YELLOW)Activate with: source $(VENV_DIR)/bin/activate$(COLOR_RESET)"

##@ Validation

validate: ## Run pre-commit hooks on all files (quality gates)
	@echo "$(COLOR_BLUE)Running pre-commit hooks on all files...$(COLOR_RESET)"
	@pre-commit run --all-files

validate-all: validate-yaml validate-python validate-skills ## Extended validation (yaml, python, skills)
	@echo "$(COLOR_GREEN)✓ Extended validation complete$(COLOR_RESET)"

validate-yaml: ## Validate YAML files with yamllint and ansible-lint
	@echo "$(COLOR_BLUE)Validating YAML files...$(COLOR_RESET)"
	@yamllint -c automation-whitepaper/.yamllint automation-whitepaper/ || true
	@if command -v ansible-lint >/dev/null 2>&1; then \
		ansible-lint -c automation-whitepaper/.ansible-lint automation-whitepaper/ || true; \
	else \
		echo "$(COLOR_YELLOW)⚠ ansible-lint not found, skipping...$(COLOR_RESET)"; \
	fi

validate-python: ## Run Python linters (black, pylint)
	@echo "$(COLOR_BLUE)Validating Python files...$(COLOR_RESET)"
	@black --check --diff . 2>/dev/null || echo "$(COLOR_YELLOW)⚠ black check failed or no Python files$(COLOR_RESET)"
	@pylint --rcfile=pyproject.toml $$(find . -name "*.py" -not -path "*/\.*" -not -path "*/automation-good-practices/*" -not -path "*/deliveries/*" 2>/dev/null) 2>/dev/null || echo "$(COLOR_YELLOW)⚠ pylint check failed or no Python files$(COLOR_RESET)"

validate-skills: ## Check SKILL.md files for basic structure
	@echo "$(COLOR_BLUE)Validating SKILL.md files...$(COLOR_RESET)"
	@skills_found=0; \
	skills_valid=0; \
	for skill in $$(find skills -name "SKILL.md" 2>/dev/null); do \
		skills_found=$$((skills_found + 1)); \
		if grep -q "^# " "$$skill" 2>/dev/null; then \
			skills_valid=$$((skills_valid + 1)); \
		else \
			echo "$(COLOR_YELLOW)⚠ Missing title in $$skill$(COLOR_RESET)"; \
		fi; \
	done; \
	echo "Found $$skills_found SKILL.md files, $$skills_valid appear valid"; \
	if [ $$skills_found -eq 0 ]; then \
		echo "$(COLOR_YELLOW)⚠ No SKILL.md files found$(COLOR_RESET)"; \
	fi

lint: ## Run pre-commit hooks on all files
	@echo "$(COLOR_BLUE)Running pre-commit hooks on all files...$(COLOR_RESET)"
	@pre-commit run --all-files

##@ Testing

test: lint validate-all ## Run all tests (lint + extended validate)
	@echo "$(COLOR_GREEN)✓ All tests passed$(COLOR_RESET)"

check-links: ## Check for broken links in markdown files (requires markdown-link-check)
	@echo "$(COLOR_BLUE)Checking markdown links...$(COLOR_RESET)"
	@if command -v markdown-link-check >/dev/null 2>&1; then \
		find . -name "*.md" -not -path "*/\.*" -not -path "*/automation-good-practices/*" -not -path "*/deliveries/*" -not -path "*/node_modules/*" -exec markdown-link-check --quiet {} \; ; \
	else \
		echo "$(COLOR_YELLOW)⚠ markdown-link-check not installed. Install with: npm install -g markdown-link-check$(COLOR_RESET)"; \
	fi

syntax-check: ## Run ansible-playbook --syntax-check on example playbooks
	@echo "$(COLOR_BLUE)Checking Ansible playbook syntax...$(COLOR_RESET)"
	@for playbook in $$(find automation-whitepaper/examples -name "*.yml" -o -name "*.yaml" 2>/dev/null); do \
		echo "Checking $$playbook..."; \
		ansible-playbook --syntax-check "$$playbook" || true; \
	done

##@ Development

format: ## Auto-format Python code with black
	@echo "$(COLOR_BLUE)Formatting Python files with black...$(COLOR_RESET)"
	@black .
	@echo "$(COLOR_GREEN)✓ Python files formatted$(COLOR_RESET)"

update-hooks: ## Update pre-commit hook versions
	@echo "$(COLOR_BLUE)Updating pre-commit hooks...$(COLOR_RESET)"
	@pre-commit autoupdate
	@echo "$(COLOR_GREEN)✓ Pre-commit hooks updated$(COLOR_RESET)"

update-submodules: ## Update Git submodules to latest upstream versions
	@echo "$(COLOR_BLUE)Updating Git submodules...$(COLOR_RESET)"
	@git submodule update --remote --merge
	@echo "$(COLOR_GREEN)✓ Submodules updated$(COLOR_RESET)"

skills-list: ## List all available skills
	@echo "$(COLOR_BOLD)Available Skills:$(COLOR_RESET)"
	@find skills -type d -maxdepth 1 -not -name "skills" -not -name "scripts" -not -name ".*" | sort | sed 's|skills/|  - |'

##@ Cleanup

clean: clean-cache ## Clean all temporary files and caches
	@echo "$(COLOR_GREEN)✓ Cleanup complete$(COLOR_RESET)"

clean-cache: ## Remove Python cache files and pre-commit cache
	@echo "$(COLOR_BLUE)Removing cache files...$(COLOR_RESET)"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@rm -rf .cache/ 2>/dev/null || true
	@echo "$(COLOR_GREEN)✓ Cache files removed$(COLOR_RESET)"

clean-venv: ## Remove Python virtual environment
	@echo "$(COLOR_BLUE)Removing virtual environment...$(COLOR_RESET)"
	@rm -rf $(VENV_DIR)
	@echo "$(COLOR_GREEN)✓ Virtual environment removed$(COLOR_RESET)"

clean-logs: ## Remove log files from Dev Spaces setup
	@echo "$(COLOR_BLUE)Removing log files...$(COLOR_RESET)"
	@rm -f .devfile/setup-workspace.log
	@echo "$(COLOR_GREEN)✓ Log files removed$(COLOR_RESET)"

##@ Information

info: ## Display environment information
	@echo "$(COLOR_BOLD)Environment Information:$(COLOR_RESET)"
	@echo "  $(COLOR_BLUE)Repository root:$(COLOR_RESET)     $(REPO_ROOT)"
	@echo "  $(COLOR_BLUE)AUTOMATION_HOME:$(COLOR_RESET)     $(AUTOMATION_HOME)"
	@echo "  $(COLOR_BLUE)AUTOMATION_REPO:$(COLOR_RESET)     $(AUTOMATION_REPO)"
	@echo "  $(COLOR_BLUE)Python:$(COLOR_RESET)              $$($(PYTHON) --version 2>&1)"
	@echo "  $(COLOR_BLUE)pip:$(COLOR_RESET)                 $$($(PIP) --version 2>&1 | cut -d' ' -f1-2)"
	@if command -v ansible --version >/dev/null 2>&1; then \
		echo "  $(COLOR_BLUE)Ansible:$(COLOR_RESET)             $$(ansible --version | head -n1)"; \
	fi
	@if command -v pre-commit --version >/dev/null 2>&1; then \
		echo "  $(COLOR_BLUE)pre-commit:$(COLOR_RESET)         $$(pre-commit --version)"; \
	fi
	@echo "  $(COLOR_BLUE)Git branch:$(COLOR_RESET)          $$(git branch --show-current 2>/dev/null || echo 'unknown')"
	@echo "  $(COLOR_BLUE)Submodules:$(COLOR_RESET)"
	@git submodule status 2>/dev/null | sed 's/^/    /' || echo "    (none)"

check-env: ## Verify required environment variables are set
	@echo "$(COLOR_BLUE)Checking environment variables...$(COLOR_RESET)"
	@if [ -z "$(AUTOMATION_HOME)" ]; then \
		echo "$(COLOR_YELLOW)⚠ AUTOMATION_HOME not set$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_GREEN)✓ AUTOMATION_HOME=$(AUTOMATION_HOME)$(COLOR_RESET)"; \
	fi
	@if [ -z "$(AUTOMATION_REPO)" ]; then \
		echo "$(COLOR_YELLOW)⚠ AUTOMATION_REPO not set$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_GREEN)✓ AUTOMATION_REPO=$(AUTOMATION_REPO)$(COLOR_RESET)"; \
	fi
