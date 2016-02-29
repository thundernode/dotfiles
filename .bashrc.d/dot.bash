#The following are used so that the dot script (used to manage the dot files)
#is able to use gits autocompletion functions
source $HOME/.completion/git-completion.bash
__git_complete dot __git_main

if [ $(type -t _completion_loader) ] ; then
 eval "$(complete -p git | sed -r 's/(\s)git$/\1dot/')"

 eval "$(type __gitdir |
 sed '1d;1,/if/s|if|if [[ "$COMP_LINE" == "dot "* ]]; then\necho "$HOME/.dotfiles"\nelif|')"
fi
