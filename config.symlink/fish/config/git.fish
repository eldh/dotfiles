alias git=hub

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
# completion='$(brew --prefix)/share/zsh/site-functions/_git'
# if test -f $completion
#   source $completion
# end
# compdef _git-checkout gco


#
# Functions
#
function git_branch
    set -g git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
    if [ $status -ne 0 ]
        set -ge git_branch
        set -g git_dirty_count 0
    else
        set -g git_dirty_count (git status --porcelain  | wc -l | sed "s/ //g")
    end
end


#
# Aliases
# (sorted alphabetically)
#

alias g='git'

abbr ga='git add'
abbr gaa='git add --all'
abbr gapa='git add --patch'

abbr gb='git branch'
abbr gba='git branch -a'
abbr gbl='git blame -b -w'
abbr gbnm='git branch --no-merged'
abbr gbr='git branch --remote'

abbr gc='git commit -v'
abbr gc!='git commit -v --amend'
abbr gca='git commit -v -a'
abbr gcan!='git commit -v -a -s --no-edit --amend'
abbr gcam='git commit -a -m'
alias gcaa='git commit -v -a --amend'

abbr gcb='git checkout -b'
abbr gcf='git config --list'
abbr gcl='git clone --recursive'
abbr gclean='git clean -fd'
abbr gpristine='git reset --hard and git clean -dfx'
abbr gcm='git commit -m'
abbr gco='git checkout'
abbr gcp='git cherry-pick'
abbr gcs='git commit -S'

abbr gdca='git diff --cached'
abbr gdct='git describe --tags `git rev-list --tags --max-count=1`'
abbr gdt='git diff-tree --no-commit-id --name-only -r'
abbr gdw='git diff --word-diff'
alias gd='git diff --indent-heuristic'

abbr gf='git fetch'
abbr gfa='git fetch --all --prune'
abbr gfo='git fetch origin'

abbr gignore='git update-index --assume-unchanged'
abbr gignored='git ls-files -v | grep "^[[:lower:]]"'

abbr gsoft='git reset --soft HEAD~'

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

abbr gm='git merge'
abbr gmom='git merge origin/master'
abbr gmt='git mergetool --no-prompt'
abbr gmtvim='git mergetool --no-prompt --tool=vimdiff'
abbr gmum='git merge upstream/master'
abbr gmours='grep -lr "<<<<<<<" . | xargs git checkout --ours'

abbr gp='git push'
abbr gpd='git push --dry-run'
abbr gpv='git push -v'
alias gprune='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gpn='git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
alias gpl='git pull --rebase'

abbr gr='git rebase'
abbr gre='git rebase --autostash --autosquash'
abbr grup='git remote update'
abbr grv='git remote -v'
alias grem='git rebase --autostash --autosquash master'
alias grea='git rebase --abort'
alias grec='git rebase --continue'

abbr gup='git pull --rebase and git submodule update --init --recursive'

alias greset='git reset --hard'

alias gsps='git show --pretty=short --show-signature'
alias gst='git status -sb'
alias gsts='git stash show --text'

alias stash='git stash'
alias pop='git stash pop'
alias yolo='git add --all & git commit --amend & git push -f'
