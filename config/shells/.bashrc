clear

source ~/bash_aliases.sh

PS1='\n\[\033[33m\]\w$(__git_ps1)\n\[\033[1;33m\]$\[\033[0m\] '