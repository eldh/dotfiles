# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

zstyle ':completion:*' menu select=1
