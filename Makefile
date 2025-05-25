VENV_DIR := .venv/PY-ANSIBLE
REQUIREMENTS_FILE := requirements.txt

.PHONY: check-deps init clean customization tools java vscode media alternate lint help

deps-ok:
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

init: deps-ok $(REQUIREMENTS_FILE)
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3 -m venv $(VENV_DIR); \
	fi
	. $(VENV_DIR)/bin/activate && pip install --upgrade pip && pip install -r $(REQUIREMENTS_FILE)

clean: deps-ok
	ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

customization: deps-ok
	ansible-playbook playbooks/customization.yaml --inventory inventory/hosts.yaml --ask-become-pass

tools: deps-ok
	ansible-playbook playbooks/tools.yaml --inventory inventory/hosts.yaml --ask-become-pass

java: deps-ok
	ansible-playbook playbooks/java.yaml --inventory inventory/hosts.yaml --ask-become-pass

vscode: deps-ok
	ansible-playbook playbooks/vscode.yaml --inventory inventory/hosts.yaml --ask-become-pass

media: deps-ok
	ansible-playbook playbooks/media.yaml --inventory inventory/hosts.yaml

alternate: deps-ok
	ansible-playbook playbooks/alternate.yaml --inventory inventory/hosts.yaml --ask-become-pass

lint: deps-ok
	ansible-lint

help:
	@echo "Available targets:"
	@echo "  check-deps    - Check for required system dependencies"
	@echo "  init          - Set up py venv and install requirements"
	@echo "  clean         - Run cleanup playbook"
	@echo "  customization - Run customization playbook"
	@echo "  tools         - Run tools setup playbook"
	@echo "  java          - Run Java setup playbook"
	@echo "  vscode        - Run VSCode setup playbook"
	@echo "  media         - Run media setup playbook"
	@echo "  alternate     - Run alternate setup playbook"
	@echo "  lint          - Run ansible-lint"
