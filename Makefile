.PHONY: init update cleanup customization tools container dev media alternate server all sync lint help

help: ## show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s - %s\n", $$1, $$2}'

.deps:
	@if ! rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

init: .deps ## set up py venv and install requirements
	@ln -sf $(CURDIR)/.hooks/pre-commit.sh .git/hooks/pre-commit
	@uv sync

update: ## update dependencies and sync
	@uv lock --upgrade
	@uv sync

cleanup: ## run cleanup playbook
	@uv run ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

customization: ## run customization playbook
	@uv run ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

tools: ## run tools playbook
	@uv run ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

container: ## run container playbook
	@uv run ansible-playbook playbooks/container.yaml --inventory inventory/hosts.yaml --ask-become-pass

dev: ## run development environment playbook
	@uv run ansible-playbook playbooks/dev.yaml --inventory inventory/hosts.yaml --ask-become-pass

media: ## run media playbook
	@uv run ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

alternate: ## run alternate playbook
	@uv run ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

server: ## run server playbook
	@uv run ansible-playbook playbooks/server.yaml --inventory inventory/hosts.yaml --ask-become-pass

all: ## run all playbooks
	@uv run ansible-playbook playbooks/all.yaml --inventory inventory/hosts.yaml --ask-become-pass

sync: ## sync current settings
	@declare -a SKIP_SCRIPTS; \
	SKIP_SCRIPTS+=(""); \
	for script in ./scripts/*; do \
		script_name=$$(basename "$$script"); \
		skip=false; \
		for skip_script in "$${SKIP_SCRIPTS[@]}"; do \
			if [ "$$script_name" = "$$skip_script" ]; then \
				skip=true; \
				break; \
			fi; \
		done; \
		if [ "$$skip" = "true" ]; then \
			echo "SKIP -x $$script"; \
			continue; \
		fi; \
		if [ -x "$$script" ]; then \
			echo "EXEC -> $$script"; \
			"$$script"; \
		else \
			echo "SKIP -x $$script"; \
		fi; \
	done

lint: ## run lint checks on scripts and playbooks
	@git ls-files -z -- '*.sh' | xargs -0 -r uv run shellcheck -e SC2034
	@uv run ansible-lint
	@for file in $$(find playbooks -name "*.yaml"); do \
		uv run ansible-playbook --syntax-check "$$file" || exit 1; \
	done
