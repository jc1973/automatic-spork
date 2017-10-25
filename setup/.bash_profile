[ -f .bash_aliases ] && . .bash_aliases
export PS1='\u@\h:\w\$ '

[ -d $HOME/bin ] && export PATH=$PATH:$HOME/bin

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

eval "$(chef shell-init bash)"

[ -d $HOME/.bash_scripts ] && for f in $HOME/.bash_scripts/* ; do . ${f} ; done


export PS1='\u@\h:\w\[\033[0;93m\]$(__git_ps1 " (%s)")\[\033[0;37m\]\$ '

