# Dotfiles

Personal environment setup for macOS managed with GNU Stow and Homebrew.

## Quick Start

```bash
./scripts/bootstrap-macos.sh
```

This will:
- Install Homebrew if missing.
- Install packages from `Brewfile` (without upgrading existing packages by default).
- Restow all packages into `$HOME`.

Apply macOS defaults only when you want them:

```bash
./scripts/bootstrap-macos.sh --apply-macos-defaults
```

Preview everything first:

```bash
./scripts/bootstrap-macos.sh --dry-run
```

## Manual Setup

```bash
brew bundle --file Brewfile
./scripts/stow_all.sh
./macos/.macos # optional
```

## Notes

- Secrets stay outside git: put local env vars in `~/.env`.
