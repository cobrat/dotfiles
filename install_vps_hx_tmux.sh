#!/usr/bin/env bash
# Install Helix/tmux and download their config files on a Linux VPS.
#
# The script has four phases:
#   1. Install the small set of packages needed by tmux, Helix, and downloads.
#   2. Ensure `hx` exists, falling back to the official Helix binary release.
#   3. Download only .tmux.conf and Helix config files from this dotfiles repo.
#   4. Write those files into the target user's HOME, backing up conflicts.

set -Eeuo pipefail

# These defaults make direct bootstrap possible:
#   curl -fsSL .../install_vps_hx_tmux.sh | bash
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_RAW_BASE="${DOTFILES_RAW_BASE:-}"
SKIP_INSTALL=0
ORIGINAL_PATH="$PATH"

# Helix may be installed into ~/.local/bin below; expose it during this run even
# if the user's login shell has not added ~/.local/bin to PATH yet.
export PATH="$HOME/.local/bin:$PATH"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --raw-base URL     Raw file URL prefix (default: GitHub raw URL for branch)
  --branch BRANCH    Branch to download from when --raw-base is omitted
  --skip-install     Only download configs; do not install packages
  -h, --help         Show this help

Environment overrides:
  DOTFILES_RAW_BASE, DOTFILES_BRANCH
USAGE
}

log() {
  # Keep logs on stderr so functions can return machine-readable values on stdout.
  printf '\033[1;34m==>\033[0m %s\n' "$*" >&2
}

warn() {
  printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2
}

die() {
  printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2
  exit 1
}

run_sudo() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "This step needs root privileges. Install sudo or run as root."
  fi
}

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --raw-base)
        [[ "$#" -ge 2 ]] || die "--raw-base requires a URL"
        DOTFILES_RAW_BASE="$2"
        shift 2
        ;;
      --branch)
        [[ "$#" -ge 2 ]] || die "--branch requires a branch name"
        DOTFILES_BRANCH="$2"
        shift 2
        ;;
      --skip-install)
        SKIP_INSTALL=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done
}

install_packages() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    die "This installer is intended for Linux."
  fi

  if [[ "$SKIP_INSTALL" -eq 1 ]]; then
    log "Skipping package installation"
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
    log "Installing base packages with apt"
    run_sudo apt-get update
    run_sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates curl tmux tar xz-utils
    # Some distro repositories do not package Helix or ship an older package
    # name. Treat package-manager Helix as best effort; the release fallback
    # below will install a working hx if this command fails.
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y helix || true
    fi
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing base packages with dnf"
    run_sudo dnf install -y ca-certificates curl tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo dnf install -y helix || true
    fi
  elif command -v yum >/dev/null 2>&1; then
    log "Installing base packages with yum"
    run_sudo yum install -y ca-certificates curl tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo yum install -y helix || true
    fi
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing base packages with pacman"
    run_sudo pacman -Sy --needed --noconfirm ca-certificates curl tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo pacman -S --needed --noconfirm helix || true
    fi
  elif command -v apk >/dev/null 2>&1; then
    log "Installing base packages with apk"
    run_sudo apk add --no-cache ca-certificates curl tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo apk add --no-cache helix || true
    fi
  elif command -v zypper >/dev/null 2>&1; then
    log "Installing base packages with zypper"
    run_sudo zypper --non-interactive install ca-certificates curl tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo zypper --non-interactive install helix || true
    fi
  else
    die "Unsupported Linux package manager. Install curl, tmux, tar, and xz first, then rerun with --skip-install."
  fi
}

install_helix_release() {
  command -v curl >/dev/null 2>&1 || die "curl is required to install Helix from GitHub releases."
  command -v tar >/dev/null 2>&1 || die "tar is required to install Helix from GitHub releases."

  local target
  case "$(uname -m)" in
    x86_64|amd64)
      target="x86_64-linux"
      ;;
    aarch64|arm64)
      target="aarch64-linux"
      ;;
    *)
      die "Unsupported CPU architecture for Helix binary release: $(uname -m)"
      ;;
  esac

  log "Installing Helix from the latest GitHub release"

  local latest_url version archive url tmpdir src_dir install_root candidate
  # GitHub redirects /latest to /tag/<version>; curl reports the final URL so
  # the script does not need a JSON parser.
  latest_url="$(curl -fsSIL -o /dev/null -w '%{url_effective}' https://github.com/helix-editor/helix/releases/latest)"
  version="${latest_url##*/}"
  [[ -n "$version" ]] || die "Could not detect the latest Helix release."

  archive="helix-${version}-${target}.tar.xz"
  url="https://github.com/helix-editor/helix/releases/download/${version}/${archive}"
  tmpdir="$(mktemp -d)"

  curl -fL "$url" -o "$tmpdir/$archive"
  tar -C "$tmpdir" -xf "$tmpdir/$archive"
  src_dir=""
  for candidate in "$tmpdir"/helix-*; do
    if [[ -d "$candidate" ]]; then
      src_dir="$candidate"
      break
    fi
  done
  [[ -n "$src_dir" && -x "$src_dir/hx" && -d "$src_dir/runtime" ]] || die "Downloaded Helix archive did not contain hx and runtime."

  install_root="$HOME/.local/share/helix-release"
  mkdir -p "$install_root" "$HOME/.local/bin"
  rm -rf "$install_root/current"
  mv "$src_dir" "$install_root/current"

  # The release archive needs HELIX_RUNTIME to find grammars, queries, and
  # built-in runtime files when it is installed outside a system package.
  cat > "$HOME/.local/bin/hx" <<EOF
#!/bin/sh
export HELIX_RUNTIME="$install_root/current/runtime"
exec "$install_root/current/hx" "\$@"
EOF
  chmod +x "$HOME/.local/bin/hx"
  rm -rf "$tmpdir"
}

ensure_commands() {
  if ! command -v tmux >/dev/null 2>&1; then
    die "tmux is not installed or is not on PATH."
  fi

  if ! command -v hx >/dev/null 2>&1; then
    install_helix_release
  fi

  if ! command -v hx >/dev/null 2>&1; then
    die "hx is not installed or is not on PATH."
  fi
}

config_base_url() {
  if [[ -n "$DOTFILES_RAW_BASE" ]]; then
    printf '%s\n' "${DOTFILES_RAW_BASE%/}"
  else
    printf 'https://raw.githubusercontent.com/cobrat/dotfiles/%s\n' "$DOTFILES_BRANCH"
  fi
}

unique_backup_path() {
  local target_path="$1"
  local base_path
  local candidate_path
  local counter=1

  base_path="${target_path}.bak.$(date +%Y%m%d%H%M%S)"
  candidate_path="$base_path"

  while [[ -e "$candidate_path" || -L "$candidate_path" ]]; do
    candidate_path="${base_path}.${counter}"
    counter=$((counter + 1))
  done

  printf '%s\n' "$candidate_path"
}

backup_existing_path() {
  local target_path="$1"
  local backup_path

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    # VPS images often ship default config files. Preserve them instead of
    # overwriting so the install can be reversed manually.
    backup_path="$(unique_backup_path "$target_path")"
    mv "$target_path" "$backup_path"
    warn "Backed up existing $target_path to $backup_path"
  fi
}

ensure_real_dir() {
  local dir_path="$1"

  # Older versions of this script could leave ~/.config/helix as a symlink.
  # Replace that symlink with a real directory for downloaded files.
  if [[ -L "$dir_path" ]]; then
    backup_existing_path "$dir_path"
  elif [[ -e "$dir_path" && ! -d "$dir_path" ]]; then
    backup_existing_path "$dir_path"
  fi

  mkdir -p "$dir_path"
}

download_config_file() {
  local raw_base="$1"
  local repo_path="$2"
  local dest_path="$3"
  local url tmp_path

  url="${raw_base}/${repo_path}"
  tmp_path="$(mktemp)"

  log "Downloading $repo_path"
  if ! curl -fL "$url" -o "$tmp_path"; then
    rm -f "$tmp_path"
    die "Failed to download $url"
  fi

  mkdir -p "$(dirname "$dest_path")"
  if [[ -f "$dest_path" && ! -L "$dest_path" ]] && cmp -s "$tmp_path" "$dest_path"; then
    rm -f "$tmp_path"
    log "Already up to date: $dest_path"
    return
  fi

  backup_existing_path "$dest_path"
  mv "$tmp_path" "$dest_path"
  chmod 644 "$dest_path"
  log "Installed $dest_path"
}

download_configs() {
  local raw_base
  raw_base="$(config_base_url)"

  command -v curl >/dev/null 2>&1 || die "curl is required to download config files."

  log "Downloading configs from $raw_base"
  ensure_real_dir "$HOME/.config/helix"
  download_config_file "$raw_base" ".tmux.conf" "$HOME/.tmux.conf"
  download_config_file "$raw_base" "helix/config.toml" "$HOME/.config/helix/config.toml"
  download_config_file "$raw_base" "helix/languages.toml" "$HOME/.config/helix/languages.toml"
}

print_summary() {
  printf '\nDone.\n'
  printf '  tmux: %s\n' "$(command -v tmux)"
  printf '  hx:   %s\n' "$(command -v hx)"
  printf '  config source: %s\n' "$(config_base_url)"
  printf '  tmux config:   %s\n' "$HOME/.tmux.conf"
  printf '  hx config dir:  %s\n' "$HOME/.config/helix"

  if [[ ":$ORIGINAL_PATH:" != *":$HOME/.local/bin:"* && -x "$HOME/.local/bin/hx" ]]; then
    printf '\nNote: hx was installed to %s.\n' "$HOME/.local/bin"
    printf 'Add this directory to PATH or start a new login shell if your distro adds it from ~/.profile.\n'
  fi
}

main() {
  parse_args "$@"
  if [[ "${EUID:-$(id -u)}" -eq 0 && -n "${SUDO_USER:-}" && "${SUDO_USER:-}" != "root" ]]; then
    warn "Running via sudo; configs will be installed under $HOME. Run without sudo to configure your normal user."
  fi

  # Order matters: package installation gives us curl/tmux, command checks fill
  # in missing Helix, and config download writes the final user config files.
  install_packages
  ensure_commands
  download_configs
  print_summary
}

main "$@"
