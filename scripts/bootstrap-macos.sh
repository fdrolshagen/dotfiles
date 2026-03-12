#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run_brew=true
run_stow=true
run_defaults=false
dry_run=false
brew_upgrade=false

usage() {
  cat <<'EOF'
Usage: ./scripts/bootstrap-macos.sh [options]

Options:
  --dry-run               Preview actions without changing the system
  --skip-brew             Skip Homebrew installation and Brewfile bundle
  --skip-stow             Skip stow symlink step
  --apply-macos-defaults  Apply macOS defaults from macos/.macos (opt-in)
  --brew-upgrade          Allow brew bundle to upgrade outdated dependencies
  -h, --help              Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    --skip-brew)
      run_brew=false
      shift
      ;;
    --skip-stow)
      run_stow=false
      shift
      ;;
    --apply-macos-defaults)
      run_defaults=true
      shift
      ;;
    --brew-upgrade)
      brew_upgrade=true
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

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script is intended for macOS only."
  exit 1
fi

if $run_brew; then
  if $dry_run; then
    echo "[dry-run] Would ensure Homebrew is installed."
  fi

  if ! command -v brew >/dev/null 2>&1; then
    if $dry_run; then
      echo "[dry-run] Homebrew missing. Would install Homebrew."
    else
      echo "Homebrew not found. Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  fi

  if [[ -x /opt/homebrew/bin/brew ]] && ! $dry_run; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]] && ! $dry_run; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if $dry_run; then
    echo "[dry-run] Would run brew bundle --file \"$DOTFILES_DIR/Brewfile\" --no-upgrade"
  else
    brew_args=(bundle --file "$DOTFILES_DIR/Brewfile" --no-upgrade)
    if $brew_upgrade; then
      brew_args=(bundle --file "$DOTFILES_DIR/Brewfile" --upgrade)
    fi
    echo "Installing Brewfile dependencies..."
    brew "${brew_args[@]}"
  fi
fi

if $run_stow; then
  if $dry_run; then
    echo "Running stow dry-run..."
    "$DOTFILES_DIR/scripts/stow_all.sh" --dry-run
  else
    echo "Stowing dotfile packages..."
    "$DOTFILES_DIR/scripts/stow_all.sh"
  fi
fi

if $run_defaults; then
  if $dry_run; then
    echo "[dry-run] Would apply macOS defaults via $DOTFILES_DIR/macos/.macos"
  else
    echo "Applying macOS defaults..."
    "$DOTFILES_DIR/macos/.macos"
  fi
fi

echo "Bootstrap complete."
