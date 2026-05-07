# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# jj workspace name completion (function defined in zsh/jj.zsh).
compdef _jjws_complete_workspace jjws-cd
