VENV_DIR := .venv/PY-ANSIBLE
REQUIREMENTS_FILE := requirements.txt

.deps-ok:
	@if ! rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

.PHONY: init
init: .deps-ok $(REQUIREMENTS_FILE)
	@ln -sf $(CURDIR)/.hooks/pre-commit.sh .git/hooks/pre-commit
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3.13 -m venv $(VENV_DIR); \
	fi
	@. $(VENV_DIR)/bin/activate && pip install --upgrade pip && pip install -r $(REQUIREMENTS_FILE)

.PHONY: update
update: .deps-ok
	@rm -rf $(VENV_DIR)
	@python3.13 -m venv $(VENV_DIR)
	@. $(VENV_DIR)/bin/activate && \
	pip install --upgrade pip && \
	pip install ansible ansible-lint && \
	pip freeze > $(REQUIREMENTS_FILE)

.PHONY: cleanup
cleanup: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: customization
customization: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: tools
tools: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: container
container: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/container.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: dev
dev: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/dev.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: media
media: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

.PHONY: alternate
alternate: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: lint
lint: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-lint
	@for file in $(find playbooks -name "*.yaml"); do \
		ansible-playbook --syntax-check "$$file" || exit 1; \
	done

.PHONY: server
server: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/server.yaml --inventory inventory/hosts.yaml --ask-become-pass

# asks for password everytime
# all: cleanup customization tools container java vscode media alternate

.PHONY: all
all: .deps-ok
	@. $(VENV_DIR)/bin/activate && ansible-playbook playbooks/all.yaml --inventory inventory/hosts.yaml --ask-become-pass

.PHONY: sync
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

.PHONY: help
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
