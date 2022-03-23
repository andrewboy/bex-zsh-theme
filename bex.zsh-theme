#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[green]%}λ,%{$fg_bold[red]%}λ)"
local STATUS_COLOR="%(?,%{$fg_bold[green]%},%{$fg_bold[red]%})"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="yellow"; fi
export ZSH_COMMAND_TIME="00:00:00"

_command_time_preexec() {
  timer=${timer:-$SECONDS}
  export ZSH_COMMAND_TIME="00:00:00"
}

_command_time_precmd() {
  if [ $timer ]; then
    runtime=$(($SECONDS - $timer))
    #if [ -n "$TTY" ] && [ $timer_show -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
    timer_show=$(printf '%02d:%02d:%02d' $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60)))
    export ZSH_COMMAND_TIME="$timer_show"
    #fi
    unset timer
  fi
}

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

function get_right_prompt() {
    #if git rev-parse --git-dir > /dev/null 2>&1; then
    #    echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    #else
    #    echo -n "%{$reset_color%}"
    #fi
    echo "{235%}%*{$reset_color%}"
}

function get_dir() {
    echo "%F{118%}%~%{$reset_color%}"
}

#${(l:$COLUMNS::=:):-} #print ======
PROMPT=$'╭─%F{161%}%n%{$reset_color%} at %F{166%}%m%{$reset_color%} in $(get_dir) $(check_git_prompt_info)
%{$reset_color%}╰─'$LAMBDA' %{$reset_color%}'
#RPROMPT='$(get_right_prompt)'
#PS1='hehe'
RPROMPT=$'%{$STATUS_COLOR%}%?%{$reset_color%} %{$fg[cyan]%}($ZSH_COMMAND_TIME)%{$reset_color%} %F{242%}< %*%{$reset_color%}'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+$(git status -s | egrep '^M' | wc -l)"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!$(git status | grep 'modified:' | wc -l)"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-$(git status | grep 'deleted:' | wc -l)"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?$(git status -s -uno | wc -l)"

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

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
