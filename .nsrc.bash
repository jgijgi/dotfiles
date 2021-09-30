# svn
alias stu='svn st -u'
alias stq='svn st -q'
alias stqu='svn st -qu'
alias sre='svn revert'
alias sdi='svn diff'

# path for svn wrapper
export PATH=/opt/CollabNet_Subversion/bin:${PATH}

export WORKSPACE="/home/$USER/work"
export GEN3="$WORKSPACE/gen3"
export GEN4="$WORKSPACE/gen4"
export GEN2_HW="$WORKSPACE/gen2/hw"

function cdw() {
  cd "$WORKSPACE/$1"; pwd
}

function _cdw() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=`ls $WORKSPACE`

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _cdw cdw

# Gen2
function cdgen2() {
  branch=${1:-"trunk"}
  GEN2=$GEN2_HW/$branch
  cd $GEN2; pwd
}

function _cdgen2() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=`ls $GEN2_HW/`

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _cdgen2 cdgen2 


# Gen3
function cdgen3() {
  branch=${1:-"trunk"}
  local dir=$GEN3/$branch/svn
  cd $dir; pwd
}

function _cdgen3() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=`ls $GEN3/`

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

complete -F _cdgen3 cdgen3


# Gen4
function cdgen4() {
  branch=${1:-"gen4_trunk"}
  local dir=$GEN4/$branch/svn
  cd $dir; pwd
}

function _cdgen4() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=`ls $GEN4/`

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

complete -F _cdgen4 cdgen4

function _kdiff() {
  local cur prev opts
  local product_name=`get_product_name`
  COMPREPLY=()
  if [ $COMP_CWORD -eq 1 ]
  then
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=`ls $product_name/`
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  else 
    # get all matching files and directories
    COMPREPLY=()
  fi
}

function kdiff() {
  branch_name=$1
  local product_name=`get_product_name`
  file_to_comp=`readlink -f $2`
  target=`echo $file_to_comp | sed "s,\($product_name/\)\([^/]*\),\1$branch_name,1"`
  bin="vimdiff"
  if [[ -d $file_to_comp ]]; then
    bin="diff -r $3"
  fi
  cmd="$bin $file_to_comp $target"
  echo $cmd
  eval $cmd
}
complete -o default -F _kdiff kdiff

function kmerge() {
  branch_name=$1
  shift
  target=$1
  full_target=`readlink -f $target`
  shift
  opts=$*
  local product_name=`get_product_name`
  from=`echo $full_target | sed "s,\($product_name/\)\([^/]*\),\1$branch_name,1"`
  svn_path=`svn info $from | sed -n "s/^URL: //p"`
  bin="svn merge"
  cmd="$bin $svn_path $target $*"
  echo $cmd
  echo "OK ?"
  read answer
  if [[ $answer != "y" ]]; then
    echo "Aborted."
    return
  fi
  eval $cmd
}
complete -o default -F _kdiff kmerge

function kswitch() {
  branch_name=$1
  local product_name=`get_product_name`
  target=`pwd | sed "s,\($product_name/\)\([^/]*\),\1$branch_name,1"`
  bin="cd"
  cmd="$bin $target"
  echo $cmd
  eval $cmd
}
complete -o default -F _kdiff kswitch

# /collabwork/temp
alias cdt='cd /collabwork/temp/$USER'

function get_branch_name() {
  local branch=`pwd | egrep "(^$GEN3)|(^$GEN4)" | cut -f 6,6 -d/`
  if [ ! -z $branch ];
  then
    echo "$branch "
  else
    echo ""
  fi
}

function cdh() {
  local path=`pwd | egrep "(^$GEN3)|(^$GEN4)" | cut -f -7 -d/`
  cd $path
}

function cdhh() {
  local path=`pwd | egrep "(^$GEN3)|(^$GEN4)" | cut -f -8 -d/`
  cd $path
}

function get_product_name() {
  if [ ${PWD##$GEN4} != $PWD ]
  then
    echo $GEN4
  elif [ ${PWD##$GEN3} != $PWD ]
  then
    echo $GEN3
  else
    echo ""
  fi
}

function svn_switch() {
  # svn switch
  local url=`svn info --show-item relative-url`
  [[ $? -eq 0 ]] || return
  local curUrl=`echo $url | awk -F'/' '{print $3}'`
  local target=${url/$curUrl/$1}
  svn ls $target > /dev/null
  [[ $? -eq 0 ]] || return

  # move
  echo "svn switch $target && mv `get_product_name`/`get_branch_name` `get_product_name`/$2 && cd `get_product_name`/$2"
}

# nstools
export NSTOOLS_HOME=$WORKSPACE/nstools/trunk/

# gcc 4.8.2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=/opt/gcc-4.8.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/gcc-4.8.2/lib64:$LD_LIBRARY_PATH

# lisp
export PATH=/home/$USER/bin/:/home/$USER/work/lisp/bin/:$PATH

# license
export LM_LICENSE_FILE=1800@license0-$USER:1800@license1-$USER

function clean_svn () {
  find $* -name '*{?systemd_requires}*' -exec rm -fr {} \;
  find $* -name '*%systemd_postun nsptp.service*' -exec rm -fr {} \;
  for i in `svn st $* --no-ignore | grep '^\(?\|I\) ' | cut -c2-`; do
   rm -fr "$i"
  done
}


function multisyn_base {
  local p
  local fw="$1"
  local ext="$2"
  fw=${fw##tops/}
  fw=${fw%%/}
  local svnversion=`svnversion`
  local branch=`get_branch_name`
  branch=${branch%% }

  # test if directories already exist
  for p in `seq 0 3`; do
    if [[ -d /home/$USER/fpga_build/${fw}_${branch}_${svnversion}_${ext}_$p ]]; then
      echo "/home/$USER/fpga_build/${fw}_${branch}_${svnversion}_${ext}_$p  already exists."
      return
    fi
  done

  # no local change in release mode
  re='^[0-9]+$'
  if ! [[ $svnversion =~ $re ]] ; then
    if [[ $mode == "r" ]]; then
      echo "svnversion = $svnversion"
      return
    fi
  else
    if ! [[ $mode == "r" ]]; then
      echo "Forcing release mode !"
      mode="r"
    fi
  fi

  [[ ! -z $TMUX ]] || return;
  [[ `tmux display-message -p '#{window_panes}'` -eq 1 ]] || return;
  win_name=SYN_${fw::8}
  tmux rename-window "$win_name"
  tmux split-window -h
  tmux split-window -v
  tmux select-pane -t 0
  tmux split-window -v
  if [[ -z $WAIT_TIME ]]; then
    WAIT_TIME=0;
  fi
  for p in `seq 0 3`; do
    tmux select-pane -t $p
    tmux send-keys " sleep $((WAIT_TIME+p*100))s; ./common/scripts/synthesize.py -${mode}m $1 -w /home/$USER/fpga_build/${fw}_${branch}_${svnversion}_${ext}_$p -o 13p --grid" C-m
  done
}

function multisynr {
  mode="r"
  multisyn_base $*
}

function multisyn {
  mode=""
  multisyn_base $*
}


function multisynCus {
  [[ ! -z $TMUX ]] || return;
  [[ `tmux display-message -p '#{window_panes}'` -eq 1 ]] || return;
  local p
  local cmd="$1"
  tmux rename-window 'SYN_AUTO'
  tmux split-window -h
  tmux split-window -v
  tmux select-pane -t 0
  tmux split-window -v
  for p in `seq 0 3`; do
    tmux select-pane -t $p
    tmux send-keys " p=$p; $cmd" C-m
  done
}

function atst_test {
  local p
  local test_nb="$1"
  local dir=/atst/sucellus/$test_nb/
  if [[ -d $dir ]]; then
    tmux new-window -n $test_nb
    tmux send-keys "cd /atst/sucellus/$test_nb" C-m
    tmux send-keys "grep Command cpp*.log" C-m
  fi
}

function cpbit {
  local dir=$*
  if [[ -z $dir ]]; then
    dir=$PWD
  fi
  for d in $dir; do
    local i=`find $d -type f -wholename "*/workspace/tools_workspace/vivado/*.info"`
    if [[ ! -z $i ]]; then
      info=`sed "1p; 3,5p" $i -n | tr '\n' '|'`
      echo "==================== $info"
      j=${i/.info/{.bin,.sta.summary,.info,.tgz}}
      files=`eval "ls $j"`
      ls -l $files
      echo "= SLACK ="
      sed '130,132p' -sn  ${i/.info/.sta.summary}
      sed '15,25p' -sn  ${i/.info/_top_failin*}
      echo "cp $j /collabwork/gen4/install/hw/5.x.x/"
      echo
    fi
  done
}

function cpbit2 {
  local dir=$*
  if [[ -z $dir ]]; then
    dir=$PWD
  fi
  for d in $dir; do
    local i=`find $d -type f -wholename "*/workspace/tools_workspace/vivado/*.info"`
    if [[ ! -z $i ]]; then
      info=`sed "1p; 3,5p" $i -n | tr '\n' '|'`
      echo "==================== $info"
      j=${i/.info/{.bin,.sta.summary,.info,.tgz}}
      files=`eval "ls $j"`
      for f in place.sta.summary place_post_phys_opt.sta.summary route_before_phys_opt.sta.summary sta.summary; do
        echo "== $f =="
        sed '130,132p' -sn  ${i/.info/.$f}
      done
      echo "== TIME =="
      tac ${i/.info/.log} | sed '2,2p' -sn
      echo
    fi
  done
}

# docker
if [[ $HOSTNAME == "chomsky.ns42.fr" || $HOSTNAME == "pearl.ns42.fr" ]]; then
  alias dock3='docker run -it -w $PWD -e HISTFILE=/home/$USER/.bash_history.docker --rm --hostname gen3_trunk --name gen3_trunk --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /collabwork:/collabwork:shared -v /home/$USER:/home/$USER -v /home/build/:/home/build docker-registry.ns42.fr/novatick/gen3_$USER'
  alias dock4='docker run -it -w $PWD -e HISTFILE=/home/$USER/.bash_history.docker --rm --hostname gen4_trunk --name gen4_trunk --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /collabwork:/collabwork:shared -v /home/$USER:/home/$USER -v /home/build/:/home/build docker-registry.ns42.fr/novatick/gen4_$USER'
else 
  alias dock3='docker run -it -w $PWD -e HISTFILE=/home/$USER/.bash_history.docker --rm --hostname gen3_trunk --name gen3_trunk --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /collabwork:/collabwork:shared -v /home/$USER:/home/$USER docker-registry.ns42.fr/novatick/gen3_$USER'
  alias dock4='docker run -it -w $PWD -e HISTFILE=/home/$USER/.bash_history.docker --rm --hostname gen4_trunk --name gen4_trunk --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /collabwork:/collabwork:shared -v /home/$USER:/home/$USER docker-registry.ns42.fr/novatick/gen4_$USER'
fi
alias dock3_bash='docker exec -e HISTFILE=/home/$USER/.bash_history.docker -it gen3_trunk  bash -c "cd $PWD && /bin/bash"'
alias dock4_bash='docker exec -e HISTFILE=/home/$USER/.bash_history.docker -it gen4_trunk  bash -c "cd $PWD && /bin/bash"'

# by default
for i in ~/nsenv/quartus16.env ~/nsenv/vcs.env ~/nsenv/vivado.env
do
  [[ -f $i ]] && source $i
done

# grid
SGE_DIR=/usr/local/
if [[ $HOSTNAME == "boole.ns42.fr" ]]; then
  SGE_DIR=/opt/
fi

SGE_CONF=$SGE_DIR/sge/default/common/settings.sh
[[ -f $SGE_CONF ]] && source $SGE_CONF
