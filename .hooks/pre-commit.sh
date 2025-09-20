#!/usr/bin/env bash
set -euo pipefail

function block() {
    echo -e "\n\n"
    echo "$@"
    echo "[ERROR] Commit blocked."
    exit 1
}

CHECKS="ansible_lint shell_lint"

function ansible_lint() {
    local staged
    staged=$(git diff --name-only --cached --exit-code -- '*.y*ml')
    ret=$?
    if [ $ret -eq 0 ]; then
        return 0
    fi

    (ansible-lint -q) || block "[ERROR] Ansible lint failed."

    find playbooks -name "*.yaml" -print0 |
        while IFS= read -r -d '' file; do
            ansible-playbook --syntax-check "$file" 1>/dev/null || block "[ERROR] Ansible lint failed."
        done
}

function shell_lint() {
    mapfile -d '' -t staged_sh < <(git diff --cached --name-only -z --diff-filter=ACMR -- '*.sh' || true)

    if ((${#staged_sh[@]} == 0)); then
        return 0
    fi

    for f in "${staged_sh[@]}"; do
        if [[ ! -f "$f" ]]; then
            continue
        fi

        if ! shfmt -d -i 4 -- "$f"; then
            block "[ERROR] shfmt check failed for $f"
        fi

        if ! shellcheck -e SC2034 -- "$f"; then
            block "[ERROR] shellcheck failed for $f"
        fi
    done
}

for CHECK in $CHECKS; do
    ($CHECK) || exit $?
done
