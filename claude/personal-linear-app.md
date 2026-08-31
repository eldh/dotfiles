# Individual preferences — linear-app

These are my personal overrides for the linear-app repository. They take
precedence over repository skills where they conflict, and only for me.

## Never ask a bot for review on the PR

Do not post `@codex review` (or any other bot-review request) as a comment on
a pull request. The `babysit-pr` skill tells you to; skip that step. The
comment is public and permanent, and I would rather not have a queue of bot
requests in the PR timeline.

Run the review locally instead, from the worktree, and act on it yourself:

```sh
codex review --base master          # the branch's changes against master
codex review --uncommitted          # work in progress, before pushing
codex review --commit <sha>         # one commit
```

Treat the result exactly as you would a returned Codex review: triage each
finding, fix what is real, and say why you are leaving anything. When
`babysit-pr` says to wait for a fresh Codex review of the pushed head SHA,
run `codex review --base master` again instead of requesting one.

Everything else in `babysit-pr` still applies: keep watching CI, and handle
human review comments exactly as the skill says — surface them, never reply
without my approval.
