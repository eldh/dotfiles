# Create a worktree with bin/wt, then cd into it.
wt() {
  local dir
  dir="$(command wt "$@")" || return
  cd "$dir"
}
