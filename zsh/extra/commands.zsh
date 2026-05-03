# Helpers for yazi and directory trees (kept next to repo zshrc).

yy() {
  if ! command -v yazi &>/dev/null; then
    echo 'yy: yazi is not installed' >&2
    return 127
  fi
  local cwd_file
  cwd_file=$(mktemp "${TMPDIR:-/tmp}/zsh-yazi-cwd.XXXXXX") || return 1
  yazi "${@}" --cwd-file="$cwd_file"
  local cwd
  cwd=$(command cat "$cwd_file") || true
  command rm -f "$cwd_file"
  if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd" || return 1
  fi
}

tree() {
  if command -v eza &>/dev/null; then
    eza --tree --level=3 --all --ignore-glob='.git' \
      --color=always "${@}"
  elif command -v tree &>/dev/null; then
    command tree "${@}"
  else
    echo 'tree: eza is not installed' >&2
    return 127
  fi
}

dtree() {
  if ! command -v eza &>/dev/null; then
    echo 'dtree: eza is not installed' >&2
    return 127
  fi
  eza --tree --level=3 --all --only-dirs \
    --ignore-glob='.git' --color=always "${@}"
}
