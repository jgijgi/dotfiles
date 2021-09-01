#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 
for i in .vimrc .bashrc .inputrc .tmux.conf
do
    ln -is ${BASEDIR}/$i ~/$i
done

if [[ -d ~/.fzf/shell ]]; then
    ln -is ${BASEDIR}/fzf.key-bindings.bash ~/.fzf/shell/key-bindings.bash
fi
