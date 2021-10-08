#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -d ~/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 
for i in .vimrc .bashrc .inputrc .tmux.conf .bash_profile
do
    [[ ! $i -ef ${BASEDIR}/$i ]] || ln -is ${BASEDIR}/$i ~/$i
done

[[ -d ~/.fzf/shell ]] && ln -is ${BASEDIR}/fzf.key-bindings.bash ~/.fzf/shell/key-bindings.bash
