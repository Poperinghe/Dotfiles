PS1='\[\e[38;5;245m\][\u@\h:\W]\\$ \[\e[0m\]'

alias ls="ls --color=always"
alias e="sudo emacs -nw -q -l ~/.emacs"
alias dev="nix develop --extra-experimental-features nix-command --extra-experimental-features flakes"
