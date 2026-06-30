#!/usr/bin/env bash
# Adds .bac/scripts to PATH in your shell rc file.
# Usage: bash .bac/setup/install.sh
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"
EXPORT_LINE="export PATH=\"\$PATH:$SCRIPTS_DIR\""

detect_rc() {
  if [[ -n "${ZSH_VERSION:-}" ]] || [[ "$SHELL" == */zsh ]]; then
    echo "$HOME/.zshrc"
  else
    echo "$HOME/.bashrc"
  fi
}

RC_FILE="$(detect_rc)"

if grep -qF "$SCRIPTS_DIR" "$RC_FILE" 2>/dev/null; then
  echo "Já instalado em $RC_FILE — nenhuma alteração feita."
  exit 0
fi

echo "" >> "$RC_FILE"
echo "# bac scripts" >> "$RC_FILE"
echo "$EXPORT_LINE" >> "$RC_FILE"

echo "Adicionado ao $RC_FILE."
echo "Rode: source $RC_FILE"
echo "Ou abra um novo terminal."
