#!/usr/bin/env zsh

local STATUS_COLOR="%(?,%{$fg_bold[green]%},%{$fg_bold[red]%})"
# local LAMBDA="%(?,%{$fg_bold[green]%}>,%{$fg_bold[red]%}>)"
local LAMBDA="%{$STATUS_COLOR%}>"
# if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="yellow"; fi
local ZSH_COMMAND_TIME="00:00:00"
# local promptsize=${#${(%):---(%n)-at-(%m)-in-()-}}
# local pwdsize=${#${(%):-%~}}
# local gitsize=${#${(%)$(git_prompt_status)}}
# local return_status="%{$fg[red]%}%(?..=)%{$reset_color%}"

_command_time_preexec() {
  timer=${timer:-$SECONDS}
  ZSH_COMMAND_TIME="00:00:00"
}

_command_time_precmd() {
  if [ $timer ]; then
    local runtime=$(($SECONDS - $timer))
    #if [ -n "$TTY" ] && [ $timer_show -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
    timer_show=$(printf '%02d:%02d:%02d' $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60)))
    ZSH_COMMAND_TIME="$timer_show"
    #fi
    unset timer
  fi
}

function theme_precmd {
  # TERMWIDTH=$(( COLUMNS - ${ZLE_RPROMPT_INDENT:-1} ))
  # gitsize=${#${(%)$(check_git_prompt_info)}}
  # pwdsize=${#${(%):-%~}}
  # promptsize=${#${(%):---%n-at-%m-in-}}
  promptsize=${#${(%):---%n-at-%m-in-%~-%?-($ZSH_COMMAND_TIME)-<-%*-}}
  # git_size=$(check_git_prompt_info|wc -c)
}

# function theme_preexec {
#   setopt local_options extended_glob
#   # if [[ "$TERM" = "screen" ]]; then
#   local CMD=${1[(wr)^(*=*|sudo|-*)]}
#   echo -n "\ek$CMD\e\\"
#   # fi
# }

################################################################################

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "(%{$fg[blue]%}detached-head%{$reset_color%}) $(git_prompt_status)%{$reset_color%})"
        else
            echo "($(git_prompt_info)$(git_prompt_status)%{$reset_color%})"
        fi
    fi
}

# function get_right_prompt() {
#     #if git rev-parse --git-dir > /dev/null 2>&1; then
#     #    echo -n "$(git_prompt_short_sha)%{$reset_color%}"
#     #else
#     #    echo -n "%{$reset_color%}"
#     #fi
#     echo "{235%}%*{$reset_color%}"
# }

function get_dir() {
    echo "%F{118%}%~%{$reset_color%}"
}

# TRAPWINCH () {
#   BAR=$(printf '=%.0s' {1..$COLUMNS})
#   # BAR=$(printf '=%.0s' {1..$TERMWIDTH})
# }

autoload -U add-zsh-hook
add-zsh-hook precmd  _command_time_precmd
add-zsh-hook preexec _command_time_preexec
add-zsh-hook precmd  theme_precmd
# add-zsh-hook preexec theme_preexec

# Need this so the prompt will work.
setopt prompt_subst

#${(l:$COLUMNS::=:):-} #print ======
# PROMPT=$'╭─%F{161%}%n%{$reset_color%} at %F{166%}%m%{$reset_color%} in $(get_dir) ${(l:$((COLUMNS - promptsize - pwdsize - 10))::─:):-} $(check_git_prompt_info)
PROMPT=$'╭─%F{161%}%n%{$reset_color%} at %F{166%}%m%{$reset_color%} in $(get_dir) ${(l:$((COLUMNS - promptsize))::─:):-} %{$STATUS_COLOR%}%?%{$reset_color%} %{$fg[cyan]%}($ZSH_COMMAND_TIME)%{$reset_color%} %F{242%}< %*%{$reset_color%}
%{$reset_color%}╰─'$LAMBDA' %{$reset_color%}'
# PROMPT=$'%F{161%}${(l:$COLUMNS::=:):-}%{$reset_color%}'
# PROMPT=$'%F{161%}$BAR%{$reset_color%}'
# PROMPT=$'%F{161%}$TERMWIDTH%{$reset_color%}'
#RPROMPT='$(get_right_prompt)'
#PS1='hehe'
# RPROMPT='%{$STATUS_COLOR%}%?%{$reset_color%} %{$fg[cyan]%}($ZSH_COMMAND_TIME)%{$reset_color%} %F{242%}< %*%{$reset_color%} $(print $(check_git_prompt_info)|wc -m)'
# RPROMPT="%{$STATUS_COLOR%}%?%{$reset_color%} %{$fg[cyan]%}($ZSH_COMMAND_TIME)%{$reset_color%} %F{242%}< %*%{$reset_color%} $(echo $(check_git_prompt_info)|awk '{print length})'"
RPROMPT='$(check_git_prompt_info)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"#$(git status -s | egrep '^M' | wc -l)
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"#$(git status | grep 'modified:' | wc -l)
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"#$(git status | grep 'deleted:' | wc -l)
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"#$(git status -s -uno | wc -l)

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"

# git_remote_status
#ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="⟶%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="⟵%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="⇄%{$reset_color%}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"

ZSH_THEME_GIT_PROMPT_NOCACHE=1

# precmd_functions+=(_command_time_precmd)
# preexec_functions+=(_command_time_preexec)
