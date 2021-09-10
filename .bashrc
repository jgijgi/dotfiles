# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
 . /etc/bashrc
fi

# Prompt
export INPUTRC="$HOME/.inputrc"
export LANG=C

export TERM=xterm-256color

# EDITOR
export EDITOR=/usr/bin/vim

# history management
export HISTSIZE=800000
export HISTFILESIZE=100000000

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
    if [[ $# -eq 1 ]] 
    then
        ps axfo pid,user,lstart,args | less +/$1
    else
        ps axfo pid,user,lstart,args | less 
    fi
}

function hgr() { 
    cmd="history | grep $1";
    first=0;
    for i in $*
    do
        if [[ $first -ne 0 ]]
        then
            cmd="$cmd | grep $i";
        fi
        first=1
    done;
    eval $cmd;
 }

function cpold() {
    cp -rp "${1%%/}" "${1%%/}.old"
}

function cpori() {
    cp -rp "${1%%/}" "${1%%/}.ori"
}

function cpdate() {
    cur_date=`date +%Y%m%d.%H%M%S`
    for i in $*
    do
        cp -rp "${i%%/}" "${i%%/}.${cur_date}"
    done
}

function cdx() {
    cd `dirname $1`
}

function tmuxtree() {
    if [[ ! -z $1 ]]; then
        arg="+/$1"
    fi
    for s in `tmux list-sessions -F '#{session_name}'` ; do
        echo -e "\ntmux session name: $s\n--------------------";
        for p in `tmux list-panes -s -F '#{pane_pid}' -t "$s"` ; do
            pstree -p -a -A $p;
        done;
    done | less $arg
}

# make completion
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile 2>/dev/null | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

#
export PYTHONSTARTUP=/home/$USER/.pystartup

# man
export MANPATH=$MANPATH:/usr/share/man

# path 
export PATH=$PATH:/usr/local/bin

#
[[ -f ~/nsenv/.nsrc.bash ]] && source ~/nsenv/.nsrc.bash

# fzf
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
export FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# gnome-keyring
if [[ $HOSTNAME == "boole.ns42.fr" || $HOSTNAME == "chomsky.ns42.fr" || $HOSTNAME == "pearl.ns42.fr" ]]; then
  # memento to create SVN association with keyring
  # keyring_tool --create=svn 
  # keyring_tool --setdef=svn
  set +x
  tmux has &> /dev/null
  if [[ $? -eq 1 ]]; then
    tmux new-session -d -s ADMIN
    (dbus-launch --sh-syntax;  /usr/bin/gnome-keyring-daemon) > ~/.ssh.auth
    echo "Creating .ssh.auth"
  fi
  set +x
  source ~/.ssh.auth
  # re-attach tmux
  if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    if [[ $HOSTNAME == "chomsky.ns42.fr" || $HOSTNAME == "pearl.ns42.fr" ]]; then
      tmux attach
    fi
  fi
  #
  unset LC_CTYPE
fi
