VENV_DIR := .venv/PY-ANSIBLE
REQUIREMENTS_FILE := requirements.txt

.PHONY: init update cleanup customization tools container dev media alternate server all sync lint help

.deps:
	@if ! rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

init: .deps $(REQUIREMENTS_FILE)
	@ln -sf $(CURDIR)/.hooks/pre-commit.sh .git/hooks/pre-commit
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3.13 -m venv $(VENV_DIR); \
	fi
	@. $(VENV_DIR)/bin/activate && pip install --upgrade pip && pip install -r $(REQUIREMENTS_FILE)

update:
	@rm -rf $(VENV_DIR)
	@python3.13 -m venv $(VENV_DIR)
	@. $(VENV_DIR)/bin/activate && \
	pip install --upgrade pip && \
	pip install ansible ansible-lint && \
	pip freeze > $(REQUIREMENTS_FILE)

cleanup:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

customization:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

tools:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

container:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/container.yaml --inventory inventory/hosts.yaml --ask-become-pass

dev:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/dev.yaml --inventory inventory/hosts.yaml --ask-become-pass

media:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

alternate:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

server:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/server.yaml --inventory inventory/hosts.yaml --ask-become-pass

all:
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/all.yaml --inventory inventory/hosts.yaml --ask-become-pass

sync:
	@declare -a SKIP_SCRIPTS; \
	SKIP_SCRIPTS+=("sync_gnome_terminal.sh"); \
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
	@. $(VENV_DIR)/bin/activate && \
	git ls-files -z -- '*.sh' | xargs -0 -r shellcheck -e SC2034
	@. $(VENV_DIR)/bin/activate && ansible-lint
	@for file in $$(find playbooks -name "*.yaml"); do \
		. $(VENV_DIR)/bin/activate && ansible-playbook --syntax-check "$$file" || exit 1; \
	done

help:
	@echo "Available targets:"
	@echo "  init          - Set up py venv and install requirements"
	@echo "  cleanup       - Run cleanup playbook"
	@echo "  customization - Run customization playbook"
	@echo "  tools         - Run tools setup playbook"
	@echo "  container     - Run container setup playbook"
	@echo "  dev           - Run development environment setup playbook"
	@echo "  media         - Run media setup playbook"
	@echo "  alternate     - Run alternate setup playbook"
	@echo "  server        - Run server playbook"
	@echo "  all           - Run all playbooks (except server)"
	@echo "  lint          - Run ansible-lint"
	@echo "  sync          - Sync current settings"
