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

abbr -a ga git add
abbr -a gaa git add --all
abbr -a gapa git add --patch

abbr -a gb git branch
abbr -a gba git branch -a
abbr -a gbl git blame -b -w
abbr -a gbnm git branch --no-merged
abbr -a gbr git branch --remote

abbr -a gc git commit -v
abbr -a gca git commit -v -a
abbr -a gcam git commit -a -m
alias gcaa='git commit -v -a --amend'

abbr -a gcb git checkout -b
abbr -a gcf git config --list
abbr -a gcl git clone --recursive
abbr -a gclean git clean -fd
abbr -a gpristine git reset --hard and git clean -dfx
abbr -a gcm git commit -m
abbr -a gco git checkout
abbr -a gcp git cherry-pick
abbr -a gcs git commit -S

abbr -a gdca git diff --cached
abbr -a gdct git describe --tags `git rev-list --tags --max-count=1`
abbr -a gdt git diff-tree --no-commit-id --name-only -r
abbr -a gdw git diff --word-diff
alias gd='git diff --indent-heuristic'

abbr -a gf git fetch
abbr -a gfa git fetch --all --prune
abbr -a gfo git fetch origin

abbr -a gignore git update-index --assume-unchanged
abbr -a gignored git ls-files -v | grep "^[[:lower:]]"

abbr -a gsoft git reset --soft HEAD~

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

abbr -a gm git merge
abbr -a gmom git merge origin/master
abbr -a gmt git mergetool --no-prompt
abbr -a gmtvim git mergetool --no-prompt --tool=vimdiff
abbr -a gmum git merge upstream/master
abbr -a gmours grep -lr "<<<<<<<" . | xargs git checkout --ours

abbr -a gp git push
abbr -a gpd git push --dry-run
abbr -a gpv git push -v
alias gprune='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gpn='git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
alias gpl='git pull --rebase'

abbr -a gr git rebase
abbr -a gre git rebase --autostash --autosquash
abbr -a grup git remote update
abbr -a grv git remote -v
alias grem='git rebase --autostash --autosquash master'
alias grea='git rebase --abort'
alias grec='git rebase --continue'

abbr -a gup git pull --rebase and git submodule update --init --recursive

alias greset='git reset --hard'

alias gsps='git show --pretty=short --show-signature'
alias gst='git status -sb'
alias gsts='git stash show --text'

alias stash='git stash'
alias pop='git stash pop'
alias yolo='git add --all & git commit --amend & git push -f'
