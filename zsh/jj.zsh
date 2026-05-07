# jj (jujutsu) helpers — bookmark names are pasted directly from Linear.

# Start a new issue off latest trunk with a bookmark name pasted from Linear.
# Uses jj's builtin trunk() so it works in master- and main-based repos.
jjstart() {
  if [[ -z "$1" ]]; then
    echo "usage: jjstart <bookmark-name>" >&2
    return 1
  fi
  jj git fetch && \
  jj new 'trunk()' && \
  jj bookmark create "$1" -r @
}

# Switch the working copy to another change/bookmark.
jjsw() { jj edit "$1"; }

# Start a new change on top of a branch (yours, a coworker's, an agent's).
jjon() { jj git fetch && jj new "$1"; }

# First push of a bookmark.
jjpush() { jj git push --allow-new; }

# Update an existing PR: move bookmark forward to @-, then push.
jjrepush() { jj tug && jj git push; }

# Push current change's bookmark and open a PR from it.
# Extra args are forwarded to `gh pr create` (e.g. --draft, --title, etc.)
jjpr() {
  # Find the bookmark pointing at @ (or the nearest ancestor)
  local bookmark
  bookmark=$(jj log -r 'heads(::@ & bookmarks())' --no-graph -T 'bookmarks.join(" ")' 2>/dev/null | awk '{print $1}')
  if [[ -z "$bookmark" ]]; then
    echo "no bookmark at or before @ — create one first" >&2
    return 1
  fi
  # Strip trailing * that jj appends to bookmarks ahead of remote
  bookmark="${bookmark%\*}"
  jj git push --allow-new && gh pr create --head "$bookmark" "$@"
}

# Fetch and list everything remote — handy for finding agent/coworker branches.
jjremote() { jj git fetch && jj bookmark list --all-remotes; }

# ============================================================================
# jj workspaces — parallel agents + a dedicated dev workspace.
# Convention: sibling dirs named <repo>-<workspace> share one .jj/store.
# ============================================================================

# Internal: path of the "default" workspace (the repo base), works from any
# workspace. Asks jj for known workspace names and strips a matching suffix
# from basename — handles workspace names with hyphens like "and-1234-fix".
_jjws_repo_base() {
  local root parent base ws candidate
  root="$(jj workspace root 2>/dev/null)" || return 1
  parent="$(dirname "$root")"
  base="$(basename "$root")"
  while IFS= read -r ws; do
    [[ -z "$ws" || "$ws" == "default" ]] && continue
    candidate="${base%-$ws}"
    if [[ "$candidate" != "$base" && -n "$candidate" ]]; then
      echo "$parent/$candidate"
      return 0
    fi
  done < <(jj --color=never workspace list 2>/dev/null | sed 's/:.*//')
  echo "$parent/$base"
}

# Create a new jj workspace as sibling dir <repo>-<name>.
# Usage: jjws-new <name> [revision]   (revision defaults to trunk())
jjws-new() {
  if [[ -z "$1" ]]; then
    echo "usage: jjws-new <name> [revision]" >&2
    return 1
  fi
  local name="$1" rev="${2:-trunk()}" base target
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  target="${base}-${name}"
  if [[ -e "$target" ]]; then
    echo "$target already exists" >&2
    return 1
  fi
  jj git fetch && jj workspace add --name "$name" -r "$rev" "$target"
}

# Create the dedicated dev workspace (where the dev server runs).
jjws-dev() { jjws-new dev "${1:-trunk()}"; }

# cd into a sibling workspace by short name. Works from any workspace.
# Usage: jjws-cd <name>
jjws-cd() {
  if [[ -z "$1" ]]; then
    echo "usage: jjws-cd <name>" >&2
    return 1
  fi
  local base target
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  target="${base}-$1"
  if [[ ! -d "$target" ]]; then
    echo "no workspace dir at $target" >&2
    return 1
  fi
  cd "$target"
}

# List all workspaces in this repo.
jjws-ls() { jj workspace list; }

# Forget a workspace and delete its directory. Confirms first.
# Usage: jjws-rm <name>
jjws-rm() {
  if [[ -z "$1" ]]; then
    echo "usage: jjws-rm <name>" >&2
    return 1
  fi
  if [[ "$1" == "default" ]]; then
    echo "refusing to remove the default workspace" >&2
    return 1
  fi
  local base target reply
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  target="${base}-$1"
  printf 'forget workspace "%s" and rm -rf %s ? [y/N] ' "$1" "$target"
  read -r reply
  [[ "$reply" == "y" || "$reply" == "Y" ]] || { echo "aborted"; return 1; }
  # If we're inside the workspace being removed, hop to the default first.
  if [[ "$(jj workspace root 2>/dev/null)" == "$target" ]]; then
    cd "$base" || return 1
  fi
  jj workspace forget "$1" && rm -rf "$target"
}

# Point the dev workspace at THIS workspace's bookmark. Creates the dev
# workspace if it doesn't exist yet. Footgun: if your @ is exactly at the
# bookmark, jj refuses the cross-workspace edit — `jj new` first to move @.
jjdev-this() {
  local base devdir bookmark
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  devdir="${base}-dev"
  if [[ "$(jj workspace root 2>/dev/null)" == "$devdir" ]]; then
    echo "already in the dev workspace — nothing to promote" >&2
    return 1
  fi
  bookmark=$(jj log -r 'heads(::@ & bookmarks())' --no-graph -T 'bookmarks.join(" ")' 2>/dev/null | awk '{print $1}')
  bookmark="${bookmark%\*}"
  if [[ -z "$bookmark" ]]; then
    echo "no bookmark at or before @ — create one first" >&2
    return 1
  fi
  if [[ ! -d "$devdir" ]]; then
    echo "creating dev workspace at $bookmark"
    jj workspace add --name dev -r "$bookmark" "$devdir"
  else
    echo "pointing dev at $bookmark"
    ( cd "$devdir" && jj edit "$bookmark" )
  fi
}

# Point the dev workspace at a bookmark; dev server hot-reloads against new code.
# Subshell — does not change the calling shell's cwd.
# Usage: jjdev <bookmark>
jjdev() {
  if [[ -z "$1" ]]; then
    echo "usage: jjdev <bookmark>" >&2
    return 1
  fi
  local base devdir
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  devdir="${base}-dev"
  if [[ ! -d "$devdir" ]]; then
    echo "no dev workspace at $devdir — run jjws-dev first" >&2
    return 1
  fi
  ( cd "$devdir" && jj edit "$1" )
}

# Pull a Linear-style branch into a fresh workspace and cd in.
# Pass the full branch name copied from Linear (e.g. eldh/lin-68881-foo);
# the workspace name is everything after the first "/" (e.g. lin-68881-foo).
# If the branch exists on origin, track it. Otherwise create it locally on
# top of trunk() — same shape as jjstart, just nested in a workspace.
# Usage: jjlinear <user/branch-name>
jjlinear() {
  if [[ -z "$1" ]]; then
    echo "usage: jjlinear <user/branch-name>" >&2
    echo "  e.g.  jjlinear eldh/lin-68881-small-screen-layout" >&2
    return 1
  fi
  if [[ "$1" != */* ]]; then
    echo "expected branch like 'user/lin-1234-foo', got '$1'" >&2
    return 1
  fi
  local full="$1" short="${1#*/}" base target rev remote_exists=0
  base="$(_jjws_repo_base)" || { echo "not in a jj repo" >&2; return 1; }
  target="${base}-${short}"

  echo "fetching from origin..."
  jj git fetch || return 1

  if jj log --ignore-working-copy --no-graph -r "${full}@origin" -T '""' >/dev/null 2>&1; then
    remote_exists=1
    rev="$full"
    # Track the remote bookmark (warns if already tracked; not fatal).
    jj bookmark track "$full" --remote=origin 2>/dev/null
  else
    rev='trunk()'
    echo "no remote bookmark '${full}' on origin — creating it locally on trunk()"
  fi

  if [[ -d "$target" ]]; then
    echo "workspace already exists at $target — cd'ing in"
    cd "$target"
    return 0
  fi
  jj workspace add --name "$short" -r "$rev" "$target" || return 1
  cd "$target" || return 1

  # Fresh local branch case: put the bookmark on the new workspace's @.
  if (( remote_exists == 0 )); then
    jj bookmark create "$full" -r @
  fi
}

# Completion helper: subordinate workspace names (excludes "default" since
# the default workspace lives at the bare repo dir, not <repo>-default).
# Registered via compdef in zsh/completion.zsh.
_jjws_complete_workspace() {
  local -a workspaces
  workspaces=(${(f)"$(jj --color=never workspace list 2>/dev/null | sed 's/:.*//' | grep -v '^default$')"})
  compadd -a workspaces
}

# Cheat sheet: common git workflows translated to jj.
jjcheat() {
  cat <<'EOF'
jj cheat sheet — common git workflows in jj
===========================================
Note: trunk() is jj's builtin revset that auto-resolves to master@origin (or
main/trunk) — use it in commands and they'll work in any repo.

Pull latest from origin/master
  git pull                  →  jj git fetch
                               (master@origin updates automatically — nothing else to do)
  pull + rebase your work   →  jj git fetch && jj rebase -d 'trunk()'

Check out a remote branch
  git checkout <name>       →  jj git fetch
                               jj bookmark track <name> --remote=origin
                               jj edit <name>
  start fresh on top of it  →  jjon <name>@origin

Create a new local branch
  git checkout -b <name>    →  jjstart <name>
                               (= jj git fetch && jj new 'trunk()' && jj bookmark create <name> -r @)

Rebase onto latest master
  git rebase origin/master  →  jj git fetch && jj rebase -d 'trunk()'
  rebase a whole bookmark   →  jj rebase -b <name> -d 'trunk()'

Push current branch
  git push -u (first push)  →  jjpush       (= jj git push --allow-new)
  git push (update PR)      →  jjrepush     (= jj tug && jj git push)
                               tug moves the bookmark forward to @-
  push + open PR            →  jjpr [--draft, --title, ... forwarded to gh]
                               (finds the bookmark at/before @, pushes, gh pr create)
  Why: bookmarks don't auto-follow @ like git's HEAD does. After `jj new` the
  bookmark stays put on the old commit, so you must drag it forward (tug)
  before pushing or the remote won't see your new work.

Switch branches locally
  git checkout <name>       →  jjsw <name>  (= jj edit <name>)
  jj edit mutates the working copy in place. Files swap under your dev server
  and it reloads — no restart needed unless deps changed.

Switch which branch/bookmark your dev server is "running"
  Same as switching branches:  jjsw <name>      → puts you AT <name> to amend it
  Or start fresh on top:       jjon <name>      → new change ON TOP of <name>,
                                                  leaves the bookmark untouched
  Either way the working copy updates in place; dev server hot-reloads.

Useful day-to-day
  jj l           short log         (alias)
  jj s           status            (alias)
  jj d           diff              (alias)
  jjremote      fetch + list all remote bookmarks

Workspaces — parallel agents + dedicated dev workspace
  Convention: sibling dirs <repo>-<name> share one .jj/store. Each workspace
  has its own @, so an agent can work in <repo>-iss-1 while a dev server runs
  in <repo>-dev. Switching what dev "runs" = jj edit <bookmark> in the dev
  workspace; files swap under the running server, no restart.

  one-time per repo (after jj git init --colocate)
    jjws-dev                       create ../<repo>-dev for the dev server
                                   (then start your dev server in there)

  start an issue (typically driven by a Claude Code agent)
    jjws-new and-1234-fix-login    create ../<repo>-and-1234-fix-login at trunk()
    jjws-cd  and-1234-fix-login    cd in; point your agent at $PWD
    jj bookmark create and-1234-fix-login -r @

  pick up or start a Linear branch (paste full name from Linear)
    jjlinear eldh/lin-68881-small-screen-layout
                                   fetch; if remote branch exists, track it;
                                   else create it locally on trunk().
                                   either way: create workspace
                                   ../<repo>-lin-68881-... and cd in.

  point dev at a bookmark (the headline move)
    jjdev and-1234-fix-login       updates @ in dev workspace; server hot-reloads
                                   (subshell — your cwd doesn't change)
    jjdev-this                     same, but auto-detects the bookmark of the
                                   workspace you're currently in. creates the
                                   dev workspace if it doesn't exist yet.

  switch dev to a different in-flight issue
    jjdev and-1235-other-thing

  when the agent advances the bookmark (jjpush / jjrepush / jj tug)
    re-run:  jjdev <name>          dev follows the new tip

  housekeeping
    jjws-ls                        list workspaces (jj workspace list)
    jjws-cd <name>                 cd from any workspace, including dev
    jjws-rm <name>                 forget workspace + rm -rf its dir (confirms)
EOF
}
