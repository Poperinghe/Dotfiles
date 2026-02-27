. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
PS1='\[\e[38;5;245m\][\u@\h:\W]\\$ \[\e[0m\]'

alias e="sudo emacs -nw -q -l ~/.emacs"
alias dev="nix develop --extra-experimental-features nix-command --extra-experimental-features flakes"
