# Window title behavior similar to Fish + tmux forwarding (OSC 2).
# Idle: user@hostname: abbreviated pwd. Running first line of command shown.

[[ $TERM == dumb ]] && return 0

_dotfiles_title_sanitize() {
  emulate -L zsh
  local s=$1
  s=${s//$'\e'/<esc>}
  s=${s//$'\033'/<esc>}
  s=${s//[^[:print:]\t]/}
  (( ${#s} > 140 )) && s="${s[1,137]}..."
  print -rn -- "$s"
}

_dotfiles_title_urlencode_path() {
  emulate -L zsh
  local LC_ALL=C
  local input=$1
  local output='' char byte
  local -i i

  for (( i = 1; i <= ${#input}; i++ )); do
    char=${input[i]}
    case $char in
      [A-Za-z0-9.~_/-])
        output+=$char
        ;;
      *)
        printf -v byte '%%%02X' "'$char"
        output+=$byte
        ;;
    esac
  done

  print -rn -- "$output"
}

_dotfiles_title_precmd() {
  emulate -L zsh
  local host="${(%):-%m}"
  local dir="${(%):-%~}"
  local idle="${USER}@${host}: ${dir}"
  printf '\033]2;%s\033\\' "$( _dotfiles_title_sanitize "$idle" )"

  # OSC 7: report cwd so Ghostty/kitty can inherit it for new panes/tabs.
  # Skipped inside tmux (tmux does not forward OSC 7 to the outer terminal).
  if [[ -z ${TMUX:-} ]]; then
    printf '\e]7;file://%s%s\a' "${HOST}" "$( _dotfiles_title_urlencode_path "$PWD" )"
  fi
}

_dotfiles_title_preexec() {
  emulate -L zsh
  local cmd_raw="${${(f)1}[1]}"
  local cmd
  cmd=$( _dotfiles_title_sanitize "$cmd_raw" )
  local dir="${(%):-%~}"
  printf '\033]2;%s\033\\' "$( _dotfiles_title_sanitize "=> ${cmd} - ${dir}" )"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_title_precmd
add-zsh-hook preexec _dotfiles_title_preexec
