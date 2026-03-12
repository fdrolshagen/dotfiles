#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

dry_run=false

usage() {
  cat <<'EOF'
Usage: ./scripts/stow_all.sh [options]

Options:
  --dry-run   Show planned stow actions without changing files
  -h, --help  Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is not installed. Install it first (for example: brew install stow)."
  exit 1
fi

packages=(
  git
  zsh
  tmux
  nvim
  idea
  macos
)

echo "Running stow preflight simulation..."
for package in "${packages[@]}"; do
  if [[ -d "$package" ]]; then
    stow --restow --simulate --target "$HOME" "$package"
  else
    echo "Skipping missing package: $package"
  fi
done

if $dry_run; then
  echo "Dry run complete. No filesystem changes were made."
  exit 0
fi

for package in "${packages[@]}"; do
  if [[ -d "$package" ]]; then
    stow --restow --target "$HOME" "$package"
  fi
done

echo "Stow complete."
