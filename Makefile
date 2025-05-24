REQUIREMENTS_FILE := requirements.txt

.PHONY: init clean java vscode lint help

init: $(REQUIREMENTS_FILE)
	python3 -m venv .venv/PY-TEMP
	. .venv/PY-TEMP/bin/activate && pip install --upgrade pip && pip install -r $<

clean:
	ansible-playbook playbooks/cleanup.yaml --inventory inventory/hosts.yaml --ask-become-pass

java:
	ansible-playbook playbooks/java.yaml --inventory inventory/hosts.yaml --ask-become-pass

vscode:
	ansible-playbook playbooks/vscode.yaml --inventory inventory/hosts.yaml --ask-become-pass

lint:
	ansible-lint

help:
	@echo "Available targets:"
	@echo "  init    - Set up py venv and install requirements"
	@echo "  clean   - Run cleanup playbook"
	@echo "  java    - Run Java setup playbook"
	@echo "  vscode  - Run VSCode setup playbook"
	@echo "  lint    - Run ansible-lint"
