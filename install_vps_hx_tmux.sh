#!/usr/bin/env bash
# Install and deploy the Helix and tmux parts of this dotfiles repo on a Linux VPS.
#
# The script has four phases:
#   1. Install the small set of packages needed by tmux, Helix, and repo cloning.
#   2. Ensure `hx` exists, falling back to the official Helix binary release.
#   3. Find this dotfiles checkout, or clone it when run through curl | bash.
#   4. Symlink only the tmux and Helix config into the target user's HOME.

set -Eeuo pipefail

# These defaults make direct bootstrap possible:
#   curl -fsSL .../install_vps_hx_tmux.sh | bash
DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/cobrat/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
SKIP_INSTALL=0
ORIGINAL_PATH="$PATH"

# Helix may be installed into ~/.local/bin below; expose it during this run even
# if the user's login shell has not added ~/.local/bin to PATH yet.
export PATH="$HOME/.local/bin:$PATH"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --repo-dir DIR     Clone/use the dotfiles repo at DIR (default: ~/.dotfiles)
  --repo-url URL     Git repository URL (default: $DOTFILES_REPO_URL)
  --branch BRANCH    Git branch to clone/update (default: $DOTFILES_BRANCH)
  --skip-install     Only link configs; do not install packages
  -h, --help         Show this help

Environment overrides:
  DOTFILES_REPO_URL, DOTFILES_BRANCH, DOTFILES_DIR
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
      --repo-dir)
        [[ "$#" -ge 2 ]] || die "--repo-dir requires a path"
        DOTFILES_DIR="$2"
        shift 2
        ;;
      --repo-url)
        [[ "$#" -ge 2 ]] || die "--repo-url requires a URL"
        DOTFILES_REPO_URL="$2"
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
      ca-certificates curl git tmux tar xz-utils
    # Some distro repositories do not package Helix or ship an older package
    # name. Treat package-manager Helix as best effort; the release fallback
    # below will install a working hx if this command fails.
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y helix || true
    fi
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing base packages with dnf"
    run_sudo dnf install -y ca-certificates curl git tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo dnf install -y helix || true
    fi
  elif command -v yum >/dev/null 2>&1; then
    log "Installing base packages with yum"
    run_sudo yum install -y ca-certificates curl git tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo yum install -y helix || true
    fi
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing base packages with pacman"
    run_sudo pacman -Sy --needed --noconfirm ca-certificates curl git tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo pacman -S --needed --noconfirm helix || true
    fi
  elif command -v apk >/dev/null 2>&1; then
    log "Installing base packages with apk"
    run_sudo apk add --no-cache ca-certificates curl git tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo apk add --no-cache helix || true
    fi
  elif command -v zypper >/dev/null 2>&1; then
    log "Installing base packages with zypper"
    run_sudo zypper --non-interactive install ca-certificates curl git tmux tar xz
    if ! command -v hx >/dev/null 2>&1; then
      run_sudo zypper --non-interactive install helix || true
    fi
  else
    die "Unsupported Linux package manager. Install curl, git, tmux, tar, and xz first, then rerun with --skip-install."
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

discover_script_repo() {
  local script_path script_dir
  script_path="${BASH_SOURCE[0]:-$0}"
  script_dir="$(cd -- "$(dirname -- "$script_path")" >/dev/null 2>&1 && pwd -P || true)"

  # When run from a normal checkout, use that checkout. When run through
  # curl | bash, there is no adjacent repo, so prepare_repo clones one.
  if [[ -n "$script_dir" && -f "$script_dir/.tmux.conf" && -d "$script_dir/helix" ]]; then
    printf '%s\n' "$script_dir"
    return
  fi

  printf '%s\n' ""
}

prepare_repo() {
  local local_repo
  local_repo="$(discover_script_repo)"

  if [[ -n "$local_repo" ]]; then
    log "Using local dotfiles repo at $local_repo"
    printf '%s\n' "$local_repo"
    return
  fi

  command -v git >/dev/null 2>&1 || die "git is required to clone the dotfiles repo."

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Updating dotfiles repo at $DOTFILES_DIR"
    git -C "$DOTFILES_DIR" fetch --depth=1 origin "$DOTFILES_BRANCH"
    if git -C "$DOTFILES_DIR" rev-parse --verify "$DOTFILES_BRANCH" >/dev/null 2>&1; then
      git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
    else
      git -C "$DOTFILES_DIR" checkout -b "$DOTFILES_BRANCH" "origin/$DOTFILES_BRANCH"
    fi
    git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"
  elif [[ -e "$DOTFILES_DIR" ]]; then
    die "$DOTFILES_DIR already exists but is not a git repo."
  else
    log "Cloning dotfiles repo to $DOTFILES_DIR"
    git clone --depth=1 --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO_URL" "$DOTFILES_DIR"
  fi

  DOTFILES_DIR="$(cd "$DOTFILES_DIR" && pwd -P)"
  [[ -f "$DOTFILES_DIR/.tmux.conf" && -d "$DOTFILES_DIR/helix" ]] || die "Dotfiles repo is missing .tmux.conf or helix/."
  printf '%s\n' "$DOTFILES_DIR"
}

link_config() {
  local source_path="$1"
  local dest_path="$2"
  local backup_path

  [[ -e "$source_path" ]] || die "Missing source path: $source_path"
  mkdir -p "$(dirname "$dest_path")"

  if [[ -L "$dest_path" && "$(readlink "$dest_path")" == "$source_path" ]]; then
    log "Already linked: $dest_path"
    return
  fi

  if [[ -e "$dest_path" || -L "$dest_path" ]]; then
    # VPS images often ship default config files. Preserve them instead of
    # overwriting so the install can be reversed manually.
    backup_path="${dest_path}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest_path" "$backup_path"
    warn "Backed up existing $dest_path to $backup_path"
  fi

  ln -s "$source_path" "$dest_path"
  log "Linked $dest_path -> $source_path"
}

deploy_configs() {
  local repo_dir="$1"
  repo_dir="$(cd "$repo_dir" && pwd -P)"

  link_config "$repo_dir/.tmux.conf" "$HOME/.tmux.conf"
  link_config "$repo_dir/helix" "$HOME/.config/helix"
}

print_summary() {
  printf '\nDone.\n'
  printf '  tmux: %s\n' "$(command -v tmux)"
  printf '  hx:   %s\n' "$(command -v hx)"
  printf '  tmux config: %s\n' "$HOME/.tmux.conf"
  printf '  hx config:   %s\n' "$HOME/.config/helix"

  if [[ ":$ORIGINAL_PATH:" != *":$HOME/.local/bin:"* && -x "$HOME/.local/bin/hx" ]]; then
    printf '\nNote: hx was installed to %s.\n' "$HOME/.local/bin"
    printf 'Add this directory to PATH or start a new login shell if your distro adds it from ~/.profile.\n'
  fi
}

main() {
  parse_args "$@"
  if [[ "${EUID:-$(id -u)}" -eq 0 && -n "${SUDO_USER:-}" && "${SUDO_USER:-}" != "root" ]]; then
    warn "Running via sudo; configs will be linked under $HOME. Run without sudo to configure your normal user."
  fi

  # Order matters: package installation gives us git/curl/tmux, command checks
  # fill in missing Helix, and repo preparation supplies the config sources.
  install_packages
  ensure_commands
  local repo_dir
  repo_dir="$(prepare_repo)"
  deploy_configs "$repo_dir"
  print_summary
}

main "$@"
