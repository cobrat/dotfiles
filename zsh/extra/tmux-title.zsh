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

_dotfiles_title_precmd() {
  emulate -L zsh
  local host="${(%):-%m}"
  local dir="${(%):-%~}"
  local idle="${USER}@${host}: ${dir}"
  printf '\033]2;%s\033\\' "$( _dotfiles_title_sanitize "$idle" )"

  if [[ ${TERM_PROGRAM:-} == Apple_Terminal && -z ${TMUX:-} ]]; then
    printf '\e]7;%s\a' "$PWD"
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
