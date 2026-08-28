# Global instructions

Always use ASD-STE100!

# Model split: plan on Fable, implement via subagents

Default working mode, unless I explicitly say otherwise in a session:

- Do planning, architecture decisions, and code review yourself (the main-loop Fable model).
- Delegate implementation — writing and editing code per an agreed plan — to subagents via the Agent tool, with `model: "sonnet"` for routine work and `model: "opus"` for complex or delicate changes. Give the subagent the full plan and relevant file paths; review its changes yourself afterwards.
- Exceptions where you should just edit directly: trivial changes (a few lines, config tweaks, renames) and fixes discovered during your own review.
- If I name a model or say "do it yourself" / "don't use subagents", that overrides this default for the request.

# Working with Linear diffs and/or GitHub

When asked to "address" PR comments, whether from Codex or coworkers, first summarize them in a table with columns for the comment, assessment, and plan. Address each comment either by making a change or by replying with a concise reason no change is needed, such as when the concern is not valid or not worth acting on. Keep replies casual and concise, and do not reference git shas. For a simple comment fixed in code, "updated" is an acceptable reply. After pushing any changes and replying, resolve each thread that has been fully addressed.

# Browser testing inside cmux

When running inside cmux (`CMUX_WORKSPACE_ID` is set), use the cmux embedded browser for browser testing instead of Chrome or a Chrome DevTools/claude-in-chrome MCP — even when repo skills (e.g. linear-app's `browser-use-client`) name a Chrome-based driver. Load the `cmux-browser` skill and target a browser surface in the current workspace: `wt` workspaces have one as a tab in the top-right pane; otherwise open one with `cmux browser open --workspace "$CMUX_WORKSPACE_ID"`.

Only the driver changes: everything repo guidance says about *what to test* still applies in full — which URLs (for linear-app: `local.linear.dev` slot URLs from the `dev-environment` skill, NEVER production, and the canonical :8080 belongs to me), login flow, and prerequisites. Navigate the pane's browser there with `cmux browser <surface> goto <url>`. If a login exists in Chrome but not in the cmux browser, `cmux browser <surface> import --from chrome --domain <domain>` transfers it.

Fall back to the repo's Chrome workflow when the task genuinely needs Chrome: Blink-specific behavior, browser extensions, or full network-request inspection.

# Pi as an alternative harness

`wt --pi` (or `WT_HARNESS=pi` in `~/.localrc`) opens a worktree workspace
driven by Pi instead of Claude Code; `wt --claude` and no flag stay on Claude
Code. The repository's own `CLAUDE.md` and skills govern the session either
way — only the harness changes.

Pi has no built-in permission system, so under Pi the guard rules in
`~/.pi/agent/AGENTS.md` are the whole defence: no force push, no `gh pr
merge`, no destructive GCP or MCP change, and nothing outside the current
worktree. Plan first for anything substantial, a Linear issue above all: show
the plan and wait for approval before you change a file. `/plan` turns that
from an instruction into hard enforcement, and `/plan implement` releases it.

# Testing

Load the `testing-on-the-toilet` skill when you write, review or argue about
tests. It carries the Google Testing on the Toilet guidance — what a test
should assert, what makes it brittle, and when a test is not worth writing.

# GitHub posts

ALWAYS start every comment, reply, review, or PR description you post to GitHub (or any external service) on my behalf with the prefix:

    Written by Claude Code:

followed by a blank line. Posts on my account must never appear human-written. This applies with no exceptions — including one-word replies like "updated" — and also to subagents posting on your behalf; include this requirement in their instructions when delegating such tasks.
