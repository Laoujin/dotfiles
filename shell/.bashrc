clear

SHELLCONFIG_PATH="/C/code/dotfiles"

source $SHELLCONFIG_PATH/shell/quick_links.sh

# not exactly what I want and incomprehensible for me :)
#source $SHELLCONFIG_PATH/shell/bash_prompt.sh
PS1='\n\[\033[33m\]\w$(__git_ps1)\n\[\033[1;33m\]$\[\033[0m\] '
