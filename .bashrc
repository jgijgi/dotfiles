# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# parameters for prompt colors or tmux att
[[ -f ~/.perso.bash ]] && source ~/.perso.bash

# Prompt
export INPUTRC="$HOME/.inputrc"
export LANG=C

export TERM=xterm-256color

# EDITOR
export EDITOR=/usr/bin/vim

# history management
export HISTSIZE=800000
export HISTFILESIZE=100000000

# path
export PATH=/home/$USER/bin/:$PATH:/usr/local/bin

# common aliases
alias rm='rm -i'
alias scp='scp -rp'
alias u='cd ..'
alias uu='cd ../..'
alias bc='bc -ql'
alias ll='ls --color -la'
alias l='ls --color -la'
alias lrt='ls --color -lrat'
alias h='head'
alias du='du --si -cks -h'
alias grepc='grep --color'
alias grpe='grep'
alias greps='grep --incl=*.{hpp,hxx,h,cpp}'
alias grepv='grep --incl=*.vhd'

export RLWRAP_HOME=~/.rlwrap
alias rlwrap='rlwrap -c -s 1000000'

# functions
function nohistory() {
  unset HISTFILE
}

# ps tree-like
function pst() {
  if [[ $# -eq 1 ]]; then
    ps axfo pid,user,lstart,args | less +/$1
  else
    ps axfo pid,user,lstart,args | less
  fi
}

function hgr() {
  cmd="history | grep $1"
  first=0
  for i in $*; do
    if [[ $first -ne 0 ]]; then
      cmd="$cmd | grep $i"
    fi
    first=1
  done
  eval $cmd
}

function cpold() {
  cp -rp "${1%%/}" "${1%%/}.old"
}

function cpori() {
  cp -rp "${1%%/}" "${1%%/}.ori"
}

function cpdate() {
  cur_date=$(date +%Y%m%d.%H%M%S)
  for i in $*; do
    cp -rp "${i%%/}" "${i%%/}.${cur_date}"
  done
}

function cdx() {
  cd $(dirname $1)
}

function tmuxtree() {
  if [[ ! -z $1 ]]; then
    arg="+/$1"
  fi
  for s in $(tmux list-sessions -F '#{session_name}'); do
    echo -e "\ntmux session name: $s\n--------------------"
    for p in $(tmux list-panes -s -F '#{pane_pid}' -t "$s"); do
      pstree -p -a -A $p
    done
  done | less $arg
}

# make completion
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile 2>/dev/null | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

#
export PYTHONSTARTUP=/home/$USER/.pystartup

# man
export MANPATH=$MANPATH:/usr/share/man

#
function prompt_extra() {
  :
}
[[ -f ~/nsenv/.nsrc.bash ]] && source ~/nsenv/.nsrc.bash

# fzf
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
export FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# prompt
function get_job_number() {
  local j=$(jobs -p | wc -l)
  if [[ $j -ne 0 ]]; then
    echo "$j "
  fi
}

function myprompt() {
  local WHITE_BOLD="\[\033[001;037m\]"
  local RESET_COLOR="\[\033[000;000m\]"
  local BOLD_GREEN="\[\033[001;032m\]"
  local CYAN="\[\033[000;036m\]"
  local BOLD_RED="\[\033[001;031m\]"
  local BOLD_PURPLE="\[\033[001;035m\]"
  local BOLD_YELLOW="\[\033[001;033m\]"

  if [[ $JG_PROMPT_CONFIG -eq 1 ]]; then
    COLOR1=${BOLD_PURPLE}; COLOR2=${BOLD_GREEN}; COLOR3=${CYAN}
  elif [[ $JG_PROMPT_CONFIG -eq 2 ]]; then
    COLOR1=${BOLD_YELLOW}; COLOR2=${RESET_COLOR}; COLOR3=${BOLD_PURPLE}
  else
    COLOR1=${CYAN}; COLOR2=${BOLD_GREEN}; COLOR3=${BOLD_RED}
  fi
  PS1="${WHITE_BOLD}[${COLOR1}\u@\h ${COLOR2}\$(prompt_extra)${COLOR3}\W${WHITE_BOLD}]${RESET_COLOR}$ ${BOLD_RED}\$(get_job_number)${RESET_COLOR}"
  export PS1
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/$USER/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/$USER/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/$USER/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/$USER/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

if [ ! -f /.dockerenv ]; then
  myprompt
fi

# tmux management
if [[ $HOSTNAME == "redvm50" ]]; then
  tmux has &>/dev/null
  if [[ $? -eq 1 ]]; then
    tmux new-session -d -s ADMIN
  fi
  # re-attach tmux
  if [[ -t 1 ]] && [[ -z "$TMUX" ]]; then
    if [[ ! -z $JG_TMUX_ATTACH && $JG_TMUX_ATTACH -eq 1 ]]; then
      tmux attach
    fi
  fi
  #
  unset LC_CTYPE
fi
