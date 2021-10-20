#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -d ~/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 
LIST_OF_FILES=".vimrc .bashrc .inputrc .tmux.conf .bash_profile .pystartup"
for i in $LIST_OF_FILES
do
  [[ ~/$i -ef ${BASEDIR}/$i ]] || ln -vis ${BASEDIR}/$i ~/$i
done

for i in .perso.bash
do
  [[ ! -f ~/$i ]] || cp ${BASEDIR}/$i ~/$i
done

if [[ ! -d ~/.fzf ]]; then
  git clone https://github.com/jgijgi/fzf ~/.fzf
  ~/.fzf/install --all
fi
