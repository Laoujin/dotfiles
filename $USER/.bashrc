clear

SHELLCONFIG_PATH="/C/unix/code/bash/shellconfig"

source $SHELLCONFIG_PATH/quick_links.sh

# not exactly what I want and incomprehensible for me :)
#source $SHELLCONFIG_PATH/bash_prompt.sh
PS1='\n\[\033[33m\]\w$(__git_ps1)\n\[\033[1;33m\]$\[\033[0m\] '

sangu
echo commands: sangu, autokey, unixcode, www, dotfiles