# Create a worktree with bin/wt, then cd into it.
#
# Inside cmux, the setup script runs in the background instead:
# a new pane opens below the current one with claude on the left,
# the setup running top-right, and a spare shell bottom-right.
wt() {
  if [[ "$1" == setup ]]; then
    command wt "$@"
    return
  fi

  local dir
  if [[ -n "$CMUX_WORKSPACE_ID" ]] && command -v cmux >/dev/null; then
    dir="$(command wt --no-setup "$@")" || return
    cd "$dir" || return
    _wt_cmux_layout "$dir"
  else
    dir="$(command wt "$@")" || return
    cd "$dir"
  fi
}

# Pull a string value out of pretty-printed `cmux --json` output.
_wt_json() {
  sed -n "s/.*\"$1\" *: *\"\([^\"]*\)\".*/\1/p" | head -n1
}

_wt_cmux_layout() {
  local dir="$1" ws="$CMUX_WORKSPACE_ID"
  local out left_pane left_surf tr_pane tr_surf br_surf

  out="$(cmux --json new-pane --direction down --workspace "$ws")" || return
  left_pane="$(print -r -- "$out" | _wt_json pane_ref)"
  left_surf="$(print -r -- "$out" | _wt_json surface_ref)"

  out="$(cmux --json new-split right --workspace "$ws" --pane "$left_pane")" || return
  tr_pane="$(print -r -- "$out" | _wt_json pane_ref)"
  tr_surf="$(print -r -- "$out" | _wt_json surface_ref)"

  out="$(cmux --json new-split down --workspace "$ws" --pane "$tr_pane")" || return
  br_surf="$(print -r -- "$out" | _wt_json surface_ref)"

  # Give the new shells a beat to start before typing into them.
  sleep 0.3
  cmux send --workspace "$ws" --surface "$tr_surf" "cd ${(q)dir} && command wt setup"$'\n'
  cmux send --workspace "$ws" --surface "$br_surf" "cd ${(q)dir}"$'\n'
  cmux send --workspace "$ws" --surface "$left_surf" "cd ${(q)dir} && claude"$'\n'
  cmux focus-pane --workspace "$ws" --pane "$left_pane"
}
