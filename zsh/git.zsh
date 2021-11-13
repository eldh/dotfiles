# The rest of my fun git aliases
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
alias g='git'

alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias grem='git rebase master'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'
alias ge='git-edit-new'
alias gcaa='git commit -v -a --amend'
alias gpl='git pull --rebase'
alias gprune='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gpn='git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
alias grem='git rebase --autostash --autosquash master'
alias grea='git rebase --abort'
alias grec='git rebase --continue'
alias greset='git reset --hard'
alias gst='git status -sb'
alias stash='git stash'
alias pop='git stash pop'
alias yolo='git add --all & git commit --amend & git push -f'

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi