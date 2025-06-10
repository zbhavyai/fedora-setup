VENV_DIR := .venv/PY-ANSIBLE
REQUIREMENTS_FILE := requirements.txt

.PHONY: check-deps init cleanup customization tools container java vscode media alternate server all lint sync help

.deps-ok:
	@if ! rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

check-deps:
	@if rpm -q python3-libdnf5 > /dev/null 2>&1; then \
		echo "All required system dependencies are installed."; \
	else \
		echo "python3-libdnf5 is not installed. Please run:"; \
		echo "  sudo dnf install --assumeyes python3-libdnf5"; \
		exit 1; \
	fi

init: .deps-ok $(REQUIREMENTS_FILE)
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3 -m venv $(VENV_DIR); \
	fi
	. $(VENV_DIR)/bin/activate && pip install --upgrade pip && pip install -r $(REQUIREMENTS_FILE)

cleanup: .deps-ok
	ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

customization: .deps-ok
	ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

tools: .deps-ok
	ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

container: .deps-ok
	ansible-playbook playbooks/container.yaml --inventory inventory/hosts.yaml --ask-become-pass

java: .deps-ok
	ansible-playbook playbooks/java.yaml --inventory inventory/hosts.yaml --ask-become-pass

vscode: .deps-ok
	ansible-playbook playbooks/vscode.yaml --inventory inventory/hosts.yaml --ask-become-pass

media: .deps-ok
	ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

alternate: .deps-ok
	ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

lint: .deps-ok
	ansible-lint

server: .deps-ok
	ansible-playbook playbooks/server.yaml --inventory inventory/hosts.yaml --ask-become-pass

# asks for password everytime
# all: cleanup customization tools container java vscode media alternate

all: deps-ok
	ansible-playbook playbooks/all.yaml --inventory inventory/hosts.yaml --ask-become-pass

sync:
	@for script in ./scripts/*; do \
		if [ "$$script" = "./scripts/sync_gnome_terminal.sh" ]; then \
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

help:
	@echo "Available targets:"
	@echo "  check-deps    - Check for required system dependencies"
	@echo "  init          - Set up py venv and install requirements"
	@echo "  cleanup       - Run cleanup playbook"
	@echo "  customization - Run customization playbook"
	@echo "  tools         - Run tools setup playbook"
	@echo "  container     - Run container setup playbook"
	@echo "  java          - Run Java setup playbook"
	@echo "  vscode        - Run VSCode setup playbook"
	@echo "  media         - Run media setup playbook"
	@echo "  alternate     - Run alternate setup playbook"
	@echo "  server        - Run server playbook"
	@echo "  all           - Run all playbooks (except server)"
	@echo "  lint          - Run ansible-lint"
	@echo "  sync          - Sync current settings"
