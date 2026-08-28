#!/usr/bin/env bash
#
# install_mac.sh - symlink dotfiles into $HOME
#
# Usage: ./install_mac.sh
# Safe to re-run: existing real files are moved into backup/<timestamp>/ under
# this repo, existing symlinks are replaced in place.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------- colors ---
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_CYAN=$'\033[36m'
else
  C_RESET= C_BOLD= C_DIM= C_GREEN= C_YELLOW= C_RED= C_CYAN=
fi

say() { printf '%s\n' "$*"; }
ok() { printf '%s\n' "${C_GREEN}✔ ${C_RESET}$*"; }
warn() { printf '%s\n' "${C_YELLOW}! ${C_RESET}$*" >&2; }
err() { printf '%s\n' "${C_RED}✘ ${C_RESET}$*" >&2; }
info() { printf '%s\n' "${C_BOLD}${C_CYAN}$*${C_RESET}"; }

# show <path> -> short ~/... form for paths under $HOME
show() { printf '~%s' "${1#"$HOME"}"; }

# Counters for the summary
n_linked=0
n_current=0
n_backedup=0
n_skipped=0

# ------------------------------------------------------------------ link ---
# link <repo-relative-source> <destination>
# - creates parent dirs of destination
# - backs up a real file/dir (not a symlink) at destination into
#   backup/<timestamp>/<path-relative-to-HOME> before linking
# - leaves foreign symlinks alone (returns 1, counted as skipped)
link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"
  local label="$(show "$dst") <- $1"

  # Refuse to create a link through an ancestor symlink that points into this
  # repo: ln -s would create the new link *inside* the repo, pointing at
  # itself (e.g. ghostty/config -> ghostty/config).
  local ancestor
  ancestor="$(dirname "$dst")"
  while [ "$ancestor" != "$HOME" ] && [ "$ancestor" != "/" ]; do
    if [ -L "$ancestor" ]; then
      local link_target
      link_target="$(readlink "$ancestor")"
      if [ "$link_target" = "$DOTFILES_DIR" ] || [ "${link_target#"$DOTFILES_DIR"/}" != "$link_target" ]; then
        warn "skip     $label (parent $ancestor is a symlink into this repo: $link_target)"
        n_skipped=$((n_skipped + 1))
        return 1
      fi
    fi
    ancestor="$(dirname "$ancestor")"
  done

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    err "missing source: $src"
    n_skipped=$((n_skipped + 1))
    return 1
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ]; then
      if [ "$(readlink "$dst")" = "$src" ]; then
        ok "current  $label"
        n_current=$((n_current + 1))
        return 0
      fi
      warn "skip     $label (foreign symlink -> $(readlink "$dst"))"
      n_skipped=$((n_skipped + 1))
      return 1
    fi
    # Real file/dir -> move it into backup/<timestamp>/ once per run.
    if [ -z "${BACKUP_TS:-}" ]; then
      BACKUP_TS="$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$DOTFILES_DIR/backup/$BACKUP_TS"
    fi
    local rel="${dst#$HOME/}"
    local bakdir="$DOTFILES_DIR/backup/$BACKUP_TS/$rel"
    mkdir -p "$(dirname "$bakdir")"
    mv "$dst" "$bakdir"
    say "${C_DIM}  backup   $(show "$dst") -> backup/$BACKUP_TS/$rel${C_RESET}"
    n_backedup=$((n_backedup + 1))
  fi

  ln -s "$src" "$dst"
  ok "linked   $label"
  n_linked=$((n_linked + 1))
  return 0
}

# ------------------------------------------------------------------ main ---
info "==> Installing dotfiles from $DOTFILES_DIR"
say ""

links=(
  "tmux/tmux.conf|$HOME/.tmux.conf"
  "vim/basic.vim|$HOME/.vimrc"
  "ghostty|$HOME/.config/ghostty"
  "kitty|$HOME/.config/kitty"
  "nvim|$HOME/.config/nvim"
  "starship/starship.toml|$HOME/.config/starship.toml"
  "yazi|$HOME/.config/yazi"
  "zsh/zshrc|$HOME/.zshrc"
)

fails=0
for entry in "${links[@]}"; do
  link "${entry%%|*}" "${entry#*|}" || fails=$((fails + 1))
done

# Neovim expects this directory for undo files (see nvim/lua/config/core.lua).
mkdir -p "$HOME/.vim/undodir"
ok "ready    $(show "$HOME/.vim/undodir")"

# Enable the Conventional Commits commit-msg hook shipped in .githooks/.
if git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git -C "$DOTFILES_DIR" config core.hooksPath .githooks; then
    ok "git      commit-msg hook active (core.hooksPath=.githooks)"
  else
    warn "git      could not set core.hooksPath; run: git config core.hooksPath .githooks"
  fi
fi

# ----------------------------------------------------------------- summary -
say ""
info "==> Summary"
say "  ${C_GREEN}linked:    $n_linked${C_RESET}"
say "  current:   $n_current"
say "  backed up: $n_backedup"
if [ -n "${BACKUP_TS:-}" ]; then
  say "  backups:   $DOTFILES_DIR/backup/$BACKUP_TS/"
fi
if [ "$n_skipped" -gt 0 ]; then
  say "  ${C_YELLOW}skipped:   $n_skipped (see messages above)${C_RESET}"
else
  say "  skipped:   0"
fi
if [ "$fails" -gt 0 ]; then
  err "$fails item(s) could not be linked — fix them and re-run ./install_mac.sh"
  exit 1
fi
