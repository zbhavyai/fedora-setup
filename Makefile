.PHONY: init update cleanup customization tools container dev media alternate server all sync lint help

.deps:
	@if ! rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

init: .deps
	@ln -sf $(CURDIR)/.hooks/pre-commit.sh .git/hooks/pre-commit
	@uv sync

update:
	@uv lock --upgrade
	@uv sync

cleanup:
	@uv run ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

customization:
	@uv run ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

tools:
	@uv run ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

container:
	@uv run ansible-playbook playbooks/container.yaml --inventory inventory/hosts.yaml --ask-become-pass

dev:
	@uv run ansible-playbook playbooks/dev.yaml --inventory inventory/hosts.yaml --ask-become-pass

media:
	@uv run ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

alternate:
	@uv run ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

server:
	@uv run ansible-playbook playbooks/server.yaml --inventory inventory/hosts.yaml --ask-become-pass

all:
	@uv run ansible-playbook playbooks/all.yaml --inventory inventory/hosts.yaml --ask-become-pass

sync:
	@declare -a SKIP_SCRIPTS; \
	SKIP_SCRIPTS+=("sync_gnome_terminal.sh"); \
	SKIP_SCRIPTS+=("sync_windsurf.sh"); \
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

lint:
	@git ls-files -z -- '*.sh' | xargs -0 -r uv run shellcheck -e SC2034
	@uv run ansible-lint
	@for file in $$(find playbooks -name "*.yaml"); do \
		uv run ansible-playbook --syntax-check "$$file" || exit 1; \
	done

help:
	@echo "Available targets:"
	@echo "  init          - Set up py venv and install requirements"
	@echo "  update        - Update dependencies and sync"
	@echo "  cleanup       - Run cleanup playbook"
	@echo "  customization - Run customization playbook"
	@echo "  tools         - Run tools setup playbook"
	@echo "  container     - Run container setup playbook"
	@echo "  dev           - Run development environment setup playbook"
	@echo "  media         - Run media setup playbook"
	@echo "  alternate     - Run alternate setup playbook"
	@echo "  server        - Run server playbook"
	@echo "  all           - Run all playbooks (except server)"
	@echo "  sync          - Sync current settings"
	@echo "  lint          - Run lint checks on scripts and playbooks"
